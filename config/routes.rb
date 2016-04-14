Rails.application.routes.draw do
  devise_for :users

  resources :users
  resources :organisations, path: '/app' do
    resources :employees, except: [:index]
  end

  authenticated :user do
    root to: 'organisations#index', as: :authenticated_root
  end

  root to: 'application#home'
end
