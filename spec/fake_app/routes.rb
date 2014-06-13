FakeApp::Application.routes.draw do
  resources :users, :only => %w[index] do
    collection do
      %w[state no_action parameters_template].each do |action|
        get action
      end
    end
  end

  namespace :admin do
    resources :users, :only => %w[index]
  end
end