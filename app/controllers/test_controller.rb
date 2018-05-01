class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM customer_transactions").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "CODE= " + t.Code
        @results << "DATE= " + t.TranDate
        @results << "INVNUM= " + t.InvNum
        @results << "DOCNUM= " + t.DocNum
        @results << "TYPE= " + t.TranType
        @results << "REFERENCE= " + t.Refer
        @results << "AMOUNT= " + t.InvAmt
      end
      dbh.disconnect 

  end
end
