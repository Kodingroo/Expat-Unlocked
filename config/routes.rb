Rails.application.routes.draw do
  get 'documents/index'
  get 'documents/show'
  get 'documents/create'
  devise_for :users
  root to: 'pages#home'
  resources :user_documents, only: %i[index create show edit update]
  resources :documents, only: %i[index show create]
  # GET   /profile => profiles#show
  resource :profile, only: [ :show ]
end
