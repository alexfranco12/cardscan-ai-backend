Rails.application.routes.draw do

  resources :users

  get    "/logged_in",         to: "sessions#logged_in"
  get    "/cards/:card_id",    to: "sessions#card"
  post   "/cardscan_session",  to: "sessions#cardscan_session"
  get   "/scan-document",     to: "sessions#scan_document"
  delete "/logout",            to: "sessions#logout"
  resources :sessions, only: [:create]

  
end
