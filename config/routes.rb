Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'contacts', to: 'contacts#create'

      get 'transactions', to: 'transactions#show'
      post 'transactions', to: 'transactions#create'

      post 'users', to: 'users#create'
    end
  end
end
