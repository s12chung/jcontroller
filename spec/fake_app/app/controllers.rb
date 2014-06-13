class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

class UsersController < ApplicationController
  %w[state index no_action parameters_template].each do |action|
    class_eval <<-END
      def #{action}
      end
    END
  end
end