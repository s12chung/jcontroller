FakeApp::Application.routes.draw do
  resources :users, :only => %w[index] do
    collection do
      UsersController::DEFAULT_ACTIONS.each do |action|
        get action
      end
      get :different_action
    end
  end

  namespace :admin do
    resources :users, :only => %w[index]
  end
end