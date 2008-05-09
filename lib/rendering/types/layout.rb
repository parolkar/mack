module Mack
  module Rendering
    # Used when someone calls render(:text => "Hello World!")
    class Layout < Base
      
      ENGINES = [:erb, :markaby, :haml]
      
      def render
        Mack::Rendering::ViewBinder.render(options[:text], self.view_binder.controller, options)
      end
      
    end
  end
end