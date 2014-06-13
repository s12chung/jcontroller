class ApplicationController < ActionController::Base
  self.append_view_path File.join(File.dirname(__FILE__), "views")
end

class UsersController < ApplicationController
  def index
  end
  def no_action
  end
  def parameters_template
  end
end