require 'mack-facets'

run_once do
  
  require File.join_from_here('core.rb')
  require File.join_from_here('gems.rb')
  require File.join_from_here('plugins.rb')
  
  init_message('lib')
  
  Mack.search_path(:lib).each do |path|
    Dir.glob(File.join(path, "**/*.rb")).each do |d|
      d = File.expand_path(d)
      # puts d
      require d
    end
  end
  
end