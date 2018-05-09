class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = User.all.where('email LIKE ?', '%    %')



  end
end
