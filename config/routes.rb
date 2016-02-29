Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :events, except: [:new, :edit] do
        get :csv
      end
      resources :signups, only: [:create]
      namespace :users do
        get :me
      end
    end
  end
end
