class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    @suspects = User.all.where('email LIKE ?', '%    %')
    @suspects.each do |s|
      @results << User.find_by(email: s.email.strip)
    end


  end
end
