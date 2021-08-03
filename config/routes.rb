Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
      post :set_as_the_best, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy

  resources :rewards, only: :index
end
