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
        match = jaction.match /(.+(?=\/|#))(?:[\/#](.+?(?=\.|\?|\z))(?:\.(.+?)(?=\?|\z)(?:\?(.+(?=\z)))?)?)?/
        if match
          %w[controller_path action_name format].zip((1..3)).each do |attribute, match_index|
            value = match[match_index]
            if value; send(attribute + "=", value) end
          end
          self.params = Rack::Utils.parse_nested_query(match[4])
          if params[:jaction_params]; self.params = params[:jaction_params] end
        else
          self.action_name = jaction
        end
      end
    end

    def to_params
      [string_params, state.to_json].join(",")
    end

    def state
      self.class.controller.send(:jcontroller_state).merge({
                                                               jaction: {
                                                                   controller_path: controller_path,
                                                                   action_name: action_name,
                                                                   format: format
                                                               }
                                                           })
    end

    def params_template_path
      "#{controller_path}/#{action_name}_params"
    end

    def format=(format)
      @format = format.to_sym
    end
    def params=(params)
      @params = params.class == String ? params : HashWithIndifferentAccess.new(params)
    end

    def to_s
      s = "#{controller_path}/#{action_name}"
      if format; s += ".#{format}" end
      unless params.blank?; s += "?#{ (params.class == String ? { :jaction_params => params } : params).to_query }" end
      s
    end

    protected
    def string_params
      self.class.controller.send(:jcontroller_params, self) || (params.class == String ? params : params.to_json)
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