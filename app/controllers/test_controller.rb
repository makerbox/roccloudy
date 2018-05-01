class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM customer_transactions").fetch(:all, :Struct)
      transactions.first(5).each do |t|
        @results << t.Code
        @results << t.TranDate
        @results << t.InvNum
      end
      dbh.disconnect 

  end
end
