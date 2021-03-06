module Jcontroller
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :execute_jaction
    end

    protected
    def js(jaction, options={})
      if jaction == false
        @stop_jaction = true
      else
        self.jaction.parse(jaction)
        if jaction.class.ancestors.include? Hash; options = jaction end
        if options[:params]; self.jaction.parse options end
        if options[:redirect]; flash[:jaction] = self.jaction.to_s end
      end
    end

    def execute_flash_jaction
      flash[:jaction] ? execute_jaction(flash[:jaction]) : "".html_safe
    end
    def execute_jaction(jaction=self.jaction, options={})
      jaction = Jaction.new(jaction)
      if options.has_key? :params; jaction.parse options end
      view_context.render(
          :partial => 'jcontroller/execute_jaction',
          :locals => {
              jaction: jaction
          }
      )
    end

    #http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-different-format-in-rails
    def with_format(format, &block)
      old_formats = formats
      self.formats = [format]
      result = block.call
      self.formats = old_formats
      result
    end

    def jcontroller_state
      {
          controller_path: controller_path,
          action_name: action_name,
          method: request.method,
          path: request.env['PATH_INFO'],
          format: formats.first
      }
    end

    def jcontroller_params(action)
      if formats.first == :html
        with_format :js do
          if lookup_context.template_exists? action.params_template_path
            view_context.render(:template => action.params_template_path)
          end
        end
      end
    end
  end
end