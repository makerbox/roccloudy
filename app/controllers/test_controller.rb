class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       @lastdiscount = Discount.all.last
       @customers = Account.all.where(sort: 'U')
  end
end