require 'drb'

class TestClient
  def initialize(port)
    DRb.start_service("druby://localhost:0")
    @v = DRbObject.new_with_uri("druby://localhost:#{port}")
  end

  [:vm_defined?, :rollback_vm, :vm_ip,
   :put_file_to_vm, :get_file_from_vm,
   :run_chef_on_vm, :execute_command_on_vm,
   :shutdown_vm, :vm_running?, :initial_snapshot_made_on_vm?,
   :start_vm, :make_initial_snapshot_on_vm].each do |method_name|
     define_method method_name do |*args|
       begin
         @v.send(method_name, *args)
       rescue DRb::DRbUnknownError => e
         puts "Folowing exception was raised on server:\n#{e.unknown.buf}"
         raise e
       end
     end
   end
end
