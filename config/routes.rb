Rails.application.routes.draw do

  resources :users

  get    :logged_in,  to: "sessions#logged_in"
  delete :logout, to: "sessions#logout"
  resources :sessions, only: [:create]
end
