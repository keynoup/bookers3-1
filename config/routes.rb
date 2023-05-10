Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "home/about" => "homes#about"

  resources :books, only: [:update, :create, :index, :show, :edit, :destroy] do
    resource :favorites, only: [:create, :destroy] 
    resources :post_comments, only: [:create, :destroy]
    
  end

  resources :users, only: [:update, :index, :show, :edit]do
    member do
      get :followings, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end