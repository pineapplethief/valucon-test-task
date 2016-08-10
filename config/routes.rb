Rails.application.routes.draw do

  scope module: :web do
    root 'welcome#index'

    resources :tasks, only: [:index]

    namespace :admin do

    end
  end
end
