# Class for Devise User
class User < Sequel::Model
  plugin :devise
  plugin :timestamps, update_on_create: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
