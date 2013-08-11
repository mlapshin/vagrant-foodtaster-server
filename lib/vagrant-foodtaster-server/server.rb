class VagrantFoodtasterServer
  class Server
    def initialize(app, env)
      @env = env
      @app = app

      @sahara = Sahara::Session::Command.new(@app, @env)
    end

    def redirect_stdstreams(stdout, stderr)
      $stdout = stdout
      $stderr = stderr
    end

    def prepare_vm(vm_name)
      @env.ui.info "[FT] Preparing #{vm_name}"

      vm = get_vm(vm_name)

      if vm.state.id.to_s != 'running'
        vm.action(:up, provision_enabled: false)
      end

      unless @sahara.is_snapshot_mode_on?(vm)
        @env.ui.info "[FT] making initial snapshot of #{vm_name}"
        @sahara.on(vm)
      end
    end

    def rollback_vm(vm_name)
      vm = get_vm(vm_name)
      @env.ui.info "[FT] rollback #{vm_name}"

      @sahara.rollback(vm)
    end

    def vm_defined?(vm_name)
      @env.machine_names.include?(vm_name)
    end

    def run_chef_on_vm(vm_name, chef_config)
      vm = get_vm(vm_name)
      @env.ui.info "[FT] Running chef on #{vm_name}"

      chef_solo_config = vm.config.vm.provisioners.find { |p| p.name == :chef_solo }
      klass  = Vagrant.plugin("2").manager.provisioners[:chef_solo]
      provisioner = klass.new(vm, chef_solo_config.config)

      modified_config = vm.config.dup

      puts chef_config.inspect
      chef_config[:recipes].each { |r| modified_config.vm.provisioners[0].config.add_recipe(r) }
      puts modified_config.run_list.inspect

      provisioner.configure(modified_config)
      provisioner.provision
    end

    def execute_on_vm(vm_name, command)
      vm = get_vm(vm_name)
      exec_result = {}

      exec_result[:exit_status] = vm.communicate.sudo(command, error_check: false) do |stream_type, data|
        exec_result[stream_type] = exec_result[stream_type].to_s + data
      end

      exec_result
    end

    private

    def get_vm(vm_name)
      @env.machine(vm_name, :virtualbox)
    end
  end
end
