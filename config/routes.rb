Rails.application.routes.draw do
  devise_for :users

  get "users/sign_up"
  get "/", to: "products#index"

  resources :products do
    collection do
      post :search
    end
  end
end
