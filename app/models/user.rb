class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  has_many :schedules
  validates :name,:email,presence:true
  validates :email,uniqueness:{case_sensitive:false}
  validates :password,presence:true,allow_nil:true,length:{minimum:7}
  validates :ziel,presence:true,allow_nil:true

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string,cost:cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest,nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
