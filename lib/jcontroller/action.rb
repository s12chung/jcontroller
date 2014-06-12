module Jcontroller
  class Action
    attr_accessor :controller_path, :action_name

    def initialize
      self.controller_path  = self.class.controller.controller_path
      self.action_name = self.class.controller.action_name
    end

    def to_params
      [controller_path, action_name, {}].map {|param| param.to_json }.join(",")
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