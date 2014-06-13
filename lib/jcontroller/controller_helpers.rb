module Jcontroller
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :execute_jaction
    end

    protected
    def execute_jaction
      view_context.render(
          :partial => 'jcontroller/execute_jaction',
          :locals => {
              action: Action.new
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

    def jcontroller_params(action)
      with_format :js do
        if lookup_context.template_exists? action.params_template_path
          view_context.render(:template => action.params_template_path)
        end
      end
    end
  end
end