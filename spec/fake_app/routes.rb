FakeApp::Application.routes.draw do
  resources :users, :only => %w[index] do
    collection do
      UsersController::DEFAULT_ACTIONS.each do |action|
        get action
      end
      get :stopped
      get :redirect
      get :redirect_simple
      get :different_action
      get :manual_parameters
      get :action_and_parameters
    end
  end
  resources :superusers, :only => %w[index]

  namespace :admin do
    resources :users, :only => %w[index]
  end
end