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
    resources :users,         only: [:index, :show, :edit, :update]
  end

  get   "/search"                   => "search#search",       as: "search"
  resources :posts
  resources :recipes
  resources :comments,        only: [:create, :destroy]
  resources :foods,           only: [:create, :update, :destroy]
  resources :flows,           only: [:create, :update, :destroy]
  resources :favorites,       only: [:create, :destroy]
  resources :bookmarks,       only: [:create, :destroy]
  resources :relationships,   only: [:create, :destroy]
  resource  :items,           only: [:create, :update, :destroy]
end
