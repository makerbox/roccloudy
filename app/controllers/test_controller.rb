class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM contact_transactions").fetch(:all, :Struct)
      transactions.where(Code: 'WANDA EY').each do |t|
        @results << t.TranType
      end
      dbh.disconnect 

  end
end
