module Jcontroller
  class Action
    attr_accessor :controller_path, :action_name

    def initialize
      self.controller_path  = self.class.controller.controller_path
      self.action_name = self.class.controller.action_name
    end

    def to_params
      [controller_path.to_json, action_name.to_json, string_params].join(",")
    end

    def params_template_path
      "#{controller_path}/#{action_name}_params"
    end

    protected
    def string_params
      self.class.controller.send(:jcontroller_params, self) || {}.to_json
    end

    class << self
      def controller
        RequestStore.store[:jcontroller_action_controller]
      end

      def controller=(controller)
        RequestStore.store[:jcontroller_action_controller] = controller
      end
    end
  end
end