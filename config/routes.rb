Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :user_documents, only: %i[index create show edit update]
  resources :documents, only: %i[index show create]

  # GET   /profile => profiles#show
  # PATCH /profile => profiles#update
  # GET   /profile/edit => profiles#edit
  resource :profile, only: [ :show, :edit, :update ]
end
