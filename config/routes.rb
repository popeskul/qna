Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
      post :set_as_the_best, on: :member
    end
  end
end
