class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  has_one :account,  dependent: :destroy 
  has_one :mimic,  dependent: :destroy 
  has_many :orders,  dependent: :destroy 
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :passworde, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  after_create :assign_default_role

  # after_update :send_change_email

  def assign_default_role
  		add_role(:user)
  end

  # def send_change_email
    # AdminMailer.account_change_request('office@roccloudy.com', User.all.find_by(id: id).account).deliver_now
  # end

  def checksort(user)
    if (user.has_role? :admin) || (user.has_role? :rep)
      if user.mimic
        output = user.mimic.account.sort
      else
        output = 'R L U P'
      end
    else
      output = user.account.sort
    end
    if output == nil
      output = ' '
    end
    return output
  end 

end
