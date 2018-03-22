Rails.application.routes.draw do
  resources :wishlists
  resources :users
  get 'foursquare/callback'

  resources :sessions

  post 'wishlists/delete', to: 'wishlists#delete', as: 'remove_wishlist'
  root "sessions#new"
end
