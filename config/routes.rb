Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
      member do
        post :set_as_the_best
      end
    end
  end
end
