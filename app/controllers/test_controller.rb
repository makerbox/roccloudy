class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      @results = []

      Account.all.each do |a|
      	if existing = Account.where('code LIKE ?', '%#{a.code}%')
      		@results << 'found duplicates for ' + a.code
      		existing.each do |e|
      			@results << existing.code
      		end
      	end
      end

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
