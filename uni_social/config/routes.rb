Rails.application.routes.draw do
  devise_for :users

  root "posts#index"

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource  :like,     only: [:create, :destroy]
  end

  resources :users, only: [:show] do
    resource :follow, only: [:create, :destroy]
  end

  resource :profile, only: [:show, :edit, :update]
  resources :notifications, only: [:index] do
    patch :mark_all_read, on: :collection
    patch :mark_read,     on: :member
  end

  resources :notifications, only: [:index, :update] do
  collection do
    post :mark_all_read
  end
end




end
