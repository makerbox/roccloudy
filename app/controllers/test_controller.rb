class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      @results = []

      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # @results = dbh.execute("DELETE INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")

      dbh.disconnect 
      redirect_to 'http://roccloudy.com'
  	end
end
