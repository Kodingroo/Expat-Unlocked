Rails.application.routes.draw do
  get 'user_documents/index'
  get 'user_documents/create'
  get 'user_documents/show'
  get 'user_documents/update'
  devise_for :users
  root to: 'pages#home'
  resources :user_documents, only: %i[index create show edit update]
  resources :documents, only: %i[index show create]
  # GET   /profile => profiles#show
  resource :profile, only: [ :show ]
end
