Rails.application.routes.draw do
  root 'home#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :sessions, only: %i[create destroy]
  resources :cards do
    get 'review', to: 'cards/reviews#index', on: :collection
    member do
      patch :update_memorization_status, to: 'cards/memorization_status#update'
    end
  end
  resource :user, only: :destroy
  get 'terms', to: 'home#terms'
  get 'privacy', to: 'home#privacy'

  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
