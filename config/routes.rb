Rails.application.routes.draw do

  scope module: :web do
    root 'tasks#index'

    resources :tasks, only: [:index]

    namespace :dashboard do
      root 'tasks#index', as: :root
      resources :tasks, only: [:index]
    end

    get 'sign_in' => 'sessions#new', as: :new_user_sign_in
    post 'sign_in' => 'sessions#create', as: :user_sign_in
    delete 'sign_out' => 'sessions#destroy', as: :user_sign_out

    namespace :admin do

    end
  end
end
