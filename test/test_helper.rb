require 'rubygems'
require "test/unit"
require 'rake'
require 'fileutils'
ENV["_mack_env"] = "test"
ENV["_mack_root"] = File.join(File.dirname(__FILE__), "fake_application")

if $genosaurus_output_directory.nil?
  $genosaurus_output_directory = ENV["_mack_root"]
  puts "$genosaurus_output_directory: #{$genosaurus_output_directory}"
end

# load the mack framework:
require(File.join(File.dirname(__FILE__), "..", "lib", 'mack'))

# not quite sure why, but when you run rake you need to keep reloading the routes. this doesn't seem
# to be a problem when running script/server or when running an individual test.
require(File.join(File.dirname(__FILE__),  "fake_application", "config", "routes.rb"))


# place common methods, assertions, and other type things in this file so
# other tests will have access to them.

module Mack
  module Utils
    module Crypt
      class ReverseWorker
        
        def encrypt(x)
          x.reverse
        end
        
        def decrypt(x)
          x.reverse
        end
        
      end
    end
  end
end

class Test::Unit::TestCase
  
  def models_directory
    File.join(Mack::Configuration.app_directory, "models")
  end
  
  def migrations_directory
    File.join(database_directory, "migrations")
  end
  
  def database_directory
    File.join(Mack::Configuration.root, "db")
  end
  
  def test_directory
    File.join(Mack::Configuration.root, "test")
  end
  
  def model_generator_cleanup
    clean_test_directory
    clean_models_directory
    clean_migrations_directory
  end
  
end
