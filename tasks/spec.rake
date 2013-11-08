require 'bundler/setup'
require 'vagrant'

task :spec do
  opts = { cwd: File.expand_path('../../spec/environment', __FILE__) }
  p opts
  env = Vagrant::Environment.new(opts)
  env.cli('up')
  env.unload
end
