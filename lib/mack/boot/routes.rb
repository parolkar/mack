if __FILE__ == $0
  require 'fileutils'
  ENV["MACK_ROOT"] = File.join(FileUtils.pwd, '..', '..', '..', 'test', 'fake_application')
end

require 'mack-facets'

run_once do
  
  require File.join_from_here('lib')
  
  init_message('routes')
  
  Mack.search_path(:config).each do |path|
    f = File.join(path, 'routes.rb')
    require f if File.exists?(f)
  end
  
end