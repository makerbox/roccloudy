class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  has_one :account
  
  after_create :assign_default_role

  def assign_default_role
  	if self.email == 'web@roccloudy.com' || 'mattwerth@mattwerth.com'
  		add_role(:admin)
  	else
  		add_role(:customer)
  	end
  end
end
