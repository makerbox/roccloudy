class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%WANDA EY%'").fetch(:all, :Struct)
      @results << transactions.count
      dbh.disconnect 

  end
end
