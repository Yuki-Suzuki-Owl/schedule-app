class User < ApplicationRecord
  has_secure_password
  has_many :schedules
  validates :name,:email,presence:true
  validates :email,uniqueness:{case_sensitive:false}
  validates :password,presence:true,allow_nil:true,length:{minimum:7}
end
