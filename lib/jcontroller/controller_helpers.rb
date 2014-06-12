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
  end
end