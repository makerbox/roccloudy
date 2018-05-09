class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    @suspects = User.all.where('email LIKE ?', '%    %')
    @suspects.each do |s|
      thisuser = User.find_by(email: s.email.strip)
      @results << thisuser.email
      if thisacct = thisuser.account
        @results << thisacct.id
        @results << thisacct.code
      end
      @results << '=' * 10
    end


  end
end
