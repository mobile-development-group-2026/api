Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/sync", to: "auth#sync"

      resource :profile, only: [:show, :update], controller: "profiles" do
        resource :student, only: [:show, :update], controller: "student_profiles"
        resource :landlord, only: [:show, :update], controller: "landlord_profiles"
        resource :lifestyle, only: [:show, :update], controller: "lifestyle_profiles"
        resource :listing_preferences, only: [:show, :update], controller: "listing_profiles"
      end

      resources :users, only: [:show]

      resources :listings, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :mine
        end
        member do
          patch :mark_rented
          post :view
        end
        resources :photos, only: [:create, :destroy], controller: "listing_photos"
        resources :applications, only: [:index, :create]
        resource :favorite, only: [:create, :destroy], controller: "favorites"
      end

      resources :favorites, only: [:index]

      resources :applications, only: [:update] do
        collection { get :mine }
      end
      post "proximity_events/bulk", to: "proximity_events#bulk"
      get "analytics/onboarding_funnel",   to: "analytics#onboarding_funnel"
      get "analytics/favorites_funnel",    to: "analytics#favorites_funnel"
      get "analytics/application_approval",to: "analytics#application_approval"
      get "analytics/conversion_matrix",   to: "analytics#conversion_matrix"
    end
  end
end
