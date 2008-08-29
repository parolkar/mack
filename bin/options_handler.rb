require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'fileutils'

@options = OpenStruct.new
@options.environment = "development"

opts = OptionParser.new do |opts|
  opts.banner = "Usage: mackery <application_name> [options]"
  
  opts.on("-e [environment]") do |v|
    @options.environment = v
  end
  
end

opts.parse!(ARGV)

ENV["MACK_ENV"] = @options.environment unless ENV["MACK_ENV"]

@mack_gem_version = nil

rakefile = File.read(File.join(FileUtils.pwd, 'Rakefile'))

begin
  @mack_gem_version = rakefile.match(/gem.['"]mack['"].+['"](.+)['"]/).captures.first
rescue Exception => e
end

# if @mack_gem_version
#   puts "Using Mack version: '#{@mack_gem_version}'"
# end
