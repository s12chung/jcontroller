module Jcontroller
  module Filter
    extend ActiveSupport::Concern

    included do
      append_before_filter :set_jaction_controller
      append_before_filter :set_jaction
      append_after_filter :append_execute_jaction, unless: :redirect?

      helper_method :jaction
    end

    protected
    def jaction; @jaction end
    def set_jaction; @jaction = Jcontroller::Jaction.new end

    def set_jaction_controller; Jcontroller::Jaction.controller = self end

    def redirect?; self.status == 302 end
    def append_execute_jaction
      unless @stop_jaction
        if formats.first == :html
          partition_index = response_body[0].rindex('</body>')

          if partition_index
            head = response_body[0][0, partition_index].html_safe
            rail = response_body[0][partition_index..-1].html_safe
            response.body = head + execute_jaction + rail
          else
            response.body += execute_jaction
          end
        else
          response.body = execute_jaction({ :params => response.body })
        end
      end
    end
  end
end