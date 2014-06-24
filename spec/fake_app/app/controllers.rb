class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

class UsersController < ApplicationController
  DEFAULT_ACTIONS = %w[state no_action manually_execute]
  (%w[index] + DEFAULT_ACTIONS).each do |action|
    class_eval <<-END
      def #{action};end
    END
  end

  def parameters_template
    @parameter_string = "parameter template"
  end

  def stopped
    Jcontroller.ajax = !params[:ajax_off]
    js false
  end
  def redirect
    js({ :redirect => true })
    redirect_to users_path
  end
  def redirect_simple
    js({ :redirect => true, :params => { s: "redirect parameters" } })
    redirect_to users_path
  end
  def different_action
    js "users#index"
  end

  def manual_parameters
    js :params => { :s => "manual parameters" }
  end
  def action_and_parameters
    js "users/index", { :params => { :s => "action and manual parameters" } }
  end
end

class SuperusersController < UsersController
  def index
  end
end

class EmptyParentsController < ApplicationController
  def index
  end
end

module Admin
  class UsersController < ApplicationController
    def index
    end
  end
end