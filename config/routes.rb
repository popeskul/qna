require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  concern :voteble do
    member do
      patch :vote_up
      patch :vote_down
      delete :un_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  resources :questions, concerns: %i[voteble commentable], shallow: true do
    resources :answers, concerns: %i[voteble commentable] do
      post :set_as_the_best, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  resources :links, only: :destroy

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
