Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/sync", to: "auth#sync"

      resource :profile, only: [:show, :update], controller: "profiles" do
        resource :student, only: [:show, :update], controller: "student_profiles"
        resource :lifestyle, only: [:show, :update], controller: "lifestyle_profiles"
      end

      resources :users, only: [:show]

      resources :listings, only: [:index, :show, :create, :update, :destroy] do
        member do
          patch :mark_rented
        end
        resources :photos, only: [:create, :destroy], controller: "listing_photos"
      end
    end
  end
end
