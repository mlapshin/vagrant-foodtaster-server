module Vagrant
  module Foodtaster
    module Server
      class Server
        def initialize(app, env)
          @env = env
          @app = app

          begin
            require 'sahara/session/virtualbox'
          rescue LoadError
            raise RuntimeError, <<-EOT.strip_heredoc
              Cannot find `sahara' plugin. Please, make sure that `sahara' plugin is installed using command:
              $ vagrant plugin list

              If `sahara' plugin is not installed, install it:
              $ vagrant plugin install sahara
            EOT
          end
        end

        def version
          Vagrant::Foodtaster::Server::VERSION
        end

        def redirect_stdstreams(stdout, stderr)
          $stdout = stdout
          $stderr = stderr
        end

        def make_initial_snapshot_on_vm(vm_name)
          vm = get_vm(vm_name)
          sahara_for(vm).on
        end

        def start_vm(vm_name)
          vm = get_vm(vm_name)
          chef_run_list = get_chef_solo_run_list(vm)
          provision_types = [:shell, :puppet]

          unless chef_run_list.empty?
            provision_types << :chef_solo
          end

          vm.action(:up,
                    provision_types: provision_types,
                    provision_enabled: true)
        end

        def vm_running?(vm_name)
          vm = get_vm(vm_name)
          vm.state.id.to_s == 'running'
        end

        def initial_snapshot_made_on_vm?(vm_name)
          vm = get_vm(vm_name)
          sahara_for(vm).is_snapshot_mode_on?
        end

        def rollback_vm(vm_name)
          vm = get_vm(vm_name)

          sahara_for(vm).rollback

          # wait for SSH connection
          # workaround for MacOS issue
          retry_number = 0
          while !vm.communicate.ready? && retry_number < 20
            sleep 0.5
            retry_number += 1
          end
        end

        def shutdown_vm(vm_name)
          vm = get_vm(vm_name)

          vm.action(:halt)
        end

        def vm_ip(vm_name)
          vm = get_vm(vm_name)
          networks = vm.config.vm.networks
          private_network_conf = networks.find { |n| n.first == :private_network }

          private_network_conf ? private_network_conf.last[:ip] : nil
        end

        def put_file_to_vm(vm_name, local_fn, vm_fn)
          vm = get_vm(vm_name)
          vm.communicate.upload(local_fn, vm_fn)
        end

        def get_file_from_vm(vm_name, vm_fn, local_fn)
          vm = get_vm(vm_name)
          vm.communicate.download(vm_fn, local_fn)
        end

        def vm_defined?(vm_name)
          @env.machine_names.include?(vm_name)
        end

        def run_chef_on_vm(vm_name, current_run_config)
          vm = get_vm(vm_name)

          validate_vm!(vm)

          chef_solo_config = vm.config.vm.provisioners.find { |p| p.name == :chef_solo }

          provisioner_klass = Vagrant.plugin("2").manager.provisioners[:chef_solo]
          provisioner = provisioner_klass.new(vm, chef_solo_config.config)

          current_run_chef_solo_config = apply_current_run_config(vm.config, current_run_config)
          provisioner.configure(current_run_chef_solo_config)

          begin
            provisioner.provision
          rescue StandardError => e
            raise RuntimeError, "Chef Run failed on #{vm_name} with config #{current_run_config.inspect}.\n\nOriginal Exception was:\n#{e.class.name}\n#{e.message}"
          end
        end

        def execute_command_on_vm(vm_name, command)
          vm = get_vm(vm_name)
          exec_result = {}

          exec_result[:exit_status] = vm.communicate.sudo(command, error_check: false) do |stream_type, data|
            exec_result[stream_type] = exec_result[stream_type].to_s + data
          end

          exec_result
        end

        private

        def sahara_for(vm)
          Sahara::Session::Virtualbox.new(vm)
        end

        def get_chef_solo_run_list(vm)
          vm.config.vm.provisioners.map do |c|
            if c.name == :chef_solo
              c.config.run_list
            else
              nil
            end
          end.compact.flatten
        end

        def get_vm(vm_name)
          @env.machine(vm_name, :virtualbox)
        end

        def validate_vm!(vm)
          chef_solo_config = vm.config.vm.provisioners.find { |p| p.name == :chef_solo }

          unless chef_solo_config
            raise RuntimeError, <<-EOT.strip_heredoc
          VM '#{vm.name}' doesn't have a configured chef-solo provisioner, which is requied by Foodtaster to run specs on this VM.
          Please, add dummy chef-solo provisioner to your Vagrantfile, like this:
          config.vm.provision :chef_solo do |chef|
            chef.cookbooks_path = %w[site-cookbooks]
          end
        EOT
          end
        end

        def apply_current_run_config(vm_config, current_run_config)
          modified_config = vm_config.dup

          provisioner_index = modified_config.vm.provisioners.find_index do |prov|
            prov.name == :chef_solo
          end

          modified_config.vm.provisioners[provisioner_index].config.run_list = current_run_config[:run_list]
          modified_config.vm.provisioners[provisioner_index].config.json = current_run_config[:json]

          modified_config
        end
      end
    end
  end
end
