Rails.application.routes.draw do
  devise_for :users
  get '/', to: 'application#home'

  # devise_for :users
  resources :users
  resources :organisations, path: '/app', only: [:index, :new, :show, :create] do
    resources :employees
  end

  root 'application#home'
end
