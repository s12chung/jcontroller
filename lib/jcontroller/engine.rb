module Jcontroller
  if defined?(Rails) && defined?(Rails::Engine)
    class Engine < Rails::Engine
      initializer "jcontroller.view_helpers" do
        ActionView::Base.send :include, ViewHelpers
      end

      initializer 'jcontroller.controller' do
        ActiveSupport.on_load(:action_controller) do
          ActionController::Base.send :include, ControllerHelpers
          ActionController::Base.send :include, Filter
        end
      end
    end
  end
end