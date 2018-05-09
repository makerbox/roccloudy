class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    @suspects = User.all.where('email LIKE ?', '%    %')
    @suspects.each do |s|
      thisuser = User.find_by(email: s.email.strip)
      @results << thisuser.email
      @results << thisuser.account
    end


  end
end
