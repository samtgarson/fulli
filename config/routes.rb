Rails.application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'invitations' }

  resources :users
  resources :organisations, path: '/app' do
    resources :association, only: :update
    resources :employees, except: [:index]
    delete 'remove_user/:user_id', action: :remove_user, on: :member, as: :remove_user
    put :transfer, on: :member, as: :transfer
  end

  authenticated :user do
    root to: 'organisations#index', as: :authenticated_root
  end

  root to: 'application#home'
end
