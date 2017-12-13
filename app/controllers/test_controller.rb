class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      @results = []

      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @results = dbh.execute("DELETE FROM customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")

      dbh.disconnect 
      redirect_to 'http://roccloudy.com'
  	end
end
