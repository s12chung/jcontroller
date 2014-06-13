FakeApp::Application.routes.draw do
  resources :users, :only => %w[index] do
    collection do
      UsersController::CUSTOM_ACTIONS.each do |action|
        get action
      end
    end
  end

  namespace :admin do
    resources :users, :only => %w[index]
  end
end