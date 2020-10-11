Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations:  "users/registrations",
    sessions:       "users/sessions"
  }

  devise_scope :user do
    root  "homes#top"
  end

  get   "/users/:id/posts"        => "users#posts",       as: "users_posts"
  get   "/users/:id/recipes"      => "users#recipes",     as: "users_recipes"
  get   "/users/:id/withdrawal"   => "users#withdrawal",  as: "users_withdrawal"
  patch "/users/:id/unsubscribe"  => "users#unsubscribe", as: "users_unsubscribe"
  resources :users,           only: [:index, :show, :edit, :update]
  resources :posts
  resources :recipes
  resources :comments,        only: [:create, :destroy]
  resources :foods,           only: [:create, :destroy]
  resources :flows,           only: [:create, :destroy]
  resources :favorites,       only: [:create, :destroy]
  resources :bookmarks,       only: [:create, :destroy]
  resources :relationships,   only: [:create, :destroy]
  resources :items,           only: [:create, :destroy]
end
