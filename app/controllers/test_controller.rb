class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      @results = []

      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @results = dbh.execute("INSERT INTO customer_master (code, name, contact) VALUES ('test', 'test', 'test')")
      

      dbh.disconnect 
  end
end
