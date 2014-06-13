FakeApp::Application.routes.draw do
  resources :users, :only => %w[index] do
    collection do
      get :no_action
    end
  end
end