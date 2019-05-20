class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  def self.from_hash(hash, _id_tags = [:email], &block)
    super(hash, [:email], &block)
  end

end
