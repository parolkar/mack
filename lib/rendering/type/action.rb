require File.join(File.dirname(__FILE__), 'base')
module Mack
  module Rendering
    module Type
      class Action < Mack::Rendering::Type::Base
        
        def render
          Mack::Rendering::Engine::Registry.engines[:action].each do |e|
            @engine = engine(e).new(self.view_template)
            
            find_file(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.options[:format]}.#{@engine.extension}") do |f|
              return @engine.render(File.open(f).read, self.view_template.binder)
            end
            
          end
          raise Mack::Errors::ResourceNotFound.new(File.join(self.view_template.controller_view_path, "#{self.view_template.engine_type_value}.#{self.options[:format]}"))
        end
        
        def concat(txt, b)
          @engine.concat(txt, b)
        end
        
      end
    end
  end
end