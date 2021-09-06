# frozen_string_literal: true

# model User
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github google_oauth2 facebook]

  has_many :authorizations, dependent: :destroy
  has_many :questions, foreign_key: 'author_id', class_name: 'Question', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(obj)
    obj.author_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
