module Jcontroller
  module Filter
    extend ActiveSupport::Concern

    included do
      append_before_filter :set_jcontroller_action_controller
      append_after_filter :append_execute_jaction, unless: :redirect?
    end

    protected
    def set_jcontroller_action_controller
      Jcontroller::Action.controller = self
    end

    def append_execute_jaction
      partition_index = response_body[0].rindex('</body>')

      if partition_index
        head = response_body[0][0, partition_index].html_safe
        rail = response_body[0][partition_index..-1].html_safe
        response.body = head + execute_jaction + rail
      else
        response.body += execute_jaction
      end
    end

    def redirect?
      self.status == 302
    end
  end
end