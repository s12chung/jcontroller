module Jcontroller
  class Jaction
    ATTRIBUTES = %w[controller_path action_name format params]
    attr_accessor *ATTRIBUTES

    def initialize(jaction=nil)
      if self.class.controller
        self.controller_path  = self.class.controller.controller_path
        self.action_name = self.class.controller.action_name
        self.format = self.class.controller.formats.first
      end
      self.params = {}

      if jaction
        parse(jaction)
      end
    end

    def parse(jaction)
      if jaction.class == Jaction
        ATTRIBUTES.each do |attribute|
          self.send(attribute + "=", jaction.send(attribute))
        end
      elsif jaction.class.ancestors.include? Hash
        hash = HashWithIndifferentAccess.new(jaction)
        ATTRIBUTES.each do |attribute|
          if hash[attribute]; self.send(attribute + "=", hash[attribute]) end
        end
      else
        self.controller_path = if jaction.index("#")
                                 split = jaction.split('#')
                                 [split.first]
                               else
                                 split = jaction.split('/')
                                 split[0..-2]
                               end

        self.action_name = split.last
        unless self.controller_path.empty?
          self.controller_path = controller_path.join('/')
        end
      end
    end

    def to_params
      ([controller_path, action_name, state].map { |param| param.to_json } + [string_params]).join(",")
    end

    def state
      self.class.controller.send(:jcontroller_state).merge({
                                                               jcontroller: {
                                                                   controller_path: controller_path,
                                                                   action_name: action_name
                                                               }
                                                           })
    end

    def params_template_path
      "#{controller_path}/#{action_name}_params"
    end

    protected
    def string_params
      self.class.controller.send(:jcontroller_params, self) || params.to_json
    end

    class << self
      def controller
        RequestStore.store[:jaction_controller]
      end

      def controller=(controller)
        RequestStore.store[:jaction_controller] = controller
      end
    end
  end
end