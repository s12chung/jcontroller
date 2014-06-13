class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

class UsersController < ApplicationController
  CUSTOM_ACTIONS = %w[state no_action manually_execute parameters_template]
  (%w[index] + CUSTOM_ACTIONS).each do |action|
    class_eval <<-END
      def #{action}
      end
    END
  end
end

module Admin
  class UsersController < ApplicationController
    def index
    end
  end
end