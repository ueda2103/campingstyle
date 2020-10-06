Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations:  "users/registrations",
    sessions:       "users/sessions"
  }

  devise_scope :user do
    root  "homes#top"
  end

  scope module: :users do
    get   "/users/:id/withdrawal"   => "users#withdrawal",    as: "users_withdrawal"
    patch "/users/:id/unsubscribe"  => "users#unsubscribe",   as: "users_unsubscribe"
    get   "/search"                 => "search#search",       as: "search"
    resources :users,         only: [:index, :show, :edit, :update]
    resources :recipes
    resource  :comments,      only: [:create, :destroy]
    resource  :foods,         only: [:create, :update, :destroy]
    resource  :flows,         only: [:create, :update, :destroy]
    resource  :favorites,     only: [:create, :destroy]
    resource  :bookmarks,     only: [:create, :destroy]
    resource  :relationships, only: [:create, :destroy]
    resource  :items,         only: [:create, :update, :destroy]
  end

  resources :posts
end
