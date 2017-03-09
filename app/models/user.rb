class User < ActiveRecord::Base
  rolify
  resourcify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trees
  has_many :scenarios

  def is_admin?
  	if self.admin == true
  		return true
  	end
  	return false
  end
end
