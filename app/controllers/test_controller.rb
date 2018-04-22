class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM contact_transactions WHERE Code = 'WANDA EY'").fetch(:all, :Struct)
      transactions.each do |t|
        @results << t.TranType
      end
      dbh.disconnect 

  end
end
