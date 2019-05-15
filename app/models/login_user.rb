# frozen_string_literal: true

class LoginUser < ApplicationRecord

  self.table_name = 'login_users'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         # :registerable,
         # :recoverable, :rememberable, :validatable,
         # :trackable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  def user_data
    Teneo::DataModel::User.find_by(email: email)
  end

  def jwt_payload
    {user_id: user_data&.id}
  end

end