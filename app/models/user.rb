class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  has_one :account
  has_one :mimic
  has_many :orders
  
  after_create :assign_default_role

  def assign_default_role
  		add_role(:user)
  end

  def checksort(user)
    if !user.has_role? :admin #if they ain't admin - they just have normal sort
      @sort = user.account.sort
    else
      if user.mimic #if they is admin and have mimic - give them mimic sort
        @sort = user.mimic.account.sort
      else #if they admin without mimic - they get full sort
        @sort = 'R L U P'
      end
    end
    return @sort
  end

end
