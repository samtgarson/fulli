Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'invitations' }

  resources :users, only: [:show, :edit, :update, :destroy]
  resources :organisations, path: '/app', except: [:index] do
    delete 'remove_user/:user_id', action: :remove_user, on: :member, as: :remove_user
    put :transfer, on: :member, as: :transfer
  end

  authenticated :user do
    root to: 'organisations#show', as: :authenticated_root
  end

  root to: 'application#home'
end
