Rails.application.routes.draw do
  devise_for :users

  get "users/sign_up"
  get "/", to: "products#index"
  get "/dashboard", to: "dashboard#index", as: "dashboard"
  put "/user_admin/:id", to: "dashboard#set_user_admin", as: "set_user_admin"

  resources :products do
    collection do
      post :search
    end
  end
end
