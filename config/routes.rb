Rails.application.routes.draw do
  get 'auth0/callback', as: :auth0_callback
  get 'auth0/failure'

  get '/', to: 'application#login'
  get '/signup', to: 'organisations#new'

  resources :users
  resources :organisations, path: '/app', only: [:index, :new, :show, :create] do
    resources :employees
  end

  root 'application#login'
end
