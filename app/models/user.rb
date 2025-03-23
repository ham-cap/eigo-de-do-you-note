class User < ApplicationRecord
  has_many :cards, dependent: :destroy

  validates :name, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :email, presence: true

  class << self
    def find_or_new_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)
      find_or_initialize_by(uid: user_params[:uid], provider: user_params[:provider]) do |user|
        user.name = user_params[:name]
        user.email = user_params[:email]
        user.image = user_params[:image]
        user.provider = user_params[:provider]
        user.uid = user_params[:uid]
      end
    end

    private

    def user_params_from_auth_hash(auth_hash)
      {
        name: auth_hash[:info][:name],
        email: auth_hash[:info][:email],
        image: auth_hash[:info][:image],
        provider: auth_hash[:provider],
        uid: auth_hash[:uid]
      }
    end
  end
end
