Rails.application.routes.draw do
  devise_for :users

  resources :timelines, only: :index do
    collection do
      get "activities"
    end
  end

  resources :users, only: [:edit, :update]
  post 'posts/create', to: 'posts#create', as: :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  apipie
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post 'add_friend' => 'dev_cities#add_friend', as: :add_friend
      get 'friend_list' => 'dev_cities#friend_list', as: :friend_list
      post 'common_friend' => 'dev_cities#common_friend', as: :common_friend
      post 'subscribe' => 'dev_cities#subscribe', as: :subscribe
      post 'block' => 'dev_cities#block', as: :block
      post 'receive_updates' => 'dev_cities#receive_updates', as: :receive_updates
      match '*a' => 'errors#routing', via: :all
    end
  end
end
