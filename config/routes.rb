Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
  }

  devise_scope :user do
    root  "homes#top"
    post  "users/guest_sign_in" => "users/sessions#create_guest", as: "user_guest_session"
  end

  get   "/users/:id/posts"        => "users#posts",       as: "users_posts"
  get   "/users/:id/recipes"      => "users#recipes",     as: "users_recipes"
  get   "/users/:id/withdrawal"   => "users#withdrawal",  as: "users_withdrawal"
  patch "/users/:id/unsubscribe"  => "users#unsubscribe", as: "users_unsubscribe"
  resources :users, only: [:index, :show, :edit, :update]
  resources :posts
  resources :recipes
  resources :comments,        only: [:create, :destroy]
  resources :foods,           only: [:create, :destroy]
  resources :flows,           only: [:create, :destroy]
  resources :favorites,       only: [:create, :destroy]
  resources :bookmarks,       only: [:create, :destroy]
  resources :relationships,   only: [:create, :destroy]
  resources :items,           only: [:create, :update, :destroy]
end
