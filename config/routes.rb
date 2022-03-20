Rails.application.routes.draw do

  resources :users

  get    :logged_in,        to: "sessions#logged_in"
  post   :cardscan_session, to: "sessions#cardscan_session"
  delete :logout,           to: "sessions#logout"
  resources :sessions, only: [:create]

  
end
