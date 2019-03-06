Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get "pages/scan_info", to: "pages#scan_info", as: :scan_info
  resources :user_documents, only: %i[index create show edit update]
  resources :documents, only: %i[index show create]
  # GET   /profile => profiles#show
  resource :profile, only: [ :show ]
end
