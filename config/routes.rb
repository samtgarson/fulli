Rails.application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'invitations' }

  resources :users
  resources :organisations, path: '/app' do
    delete :remove_user, on: :member, as: :remove_user
    resources :employees, except: [:index]
  end

  authenticated :user do
    root to: 'organisations#index', as: :authenticated_root
  end

  root to: 'application#home'
end
