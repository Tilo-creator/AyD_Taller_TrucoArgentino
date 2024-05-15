# models/user.rb
class User < ActiveRecord::Base
    validates :names, presence: true
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
  end
  