FakeApp::Application.routes.draw do
  resources :users, :only => %w[index]
end