class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%A LA MOD%'").fetch(:all, :Struct)
      transactions.last(35).each do |t|
        @results << "CODE= " + t.Code.to_s
        @results << "DATE= " + t.TranDate.to_s
        @results << "INVNUM= " + t.InvNum.to_s
        @results << "DOCNUM= " + t.DocNum.to_s
        @results << "TYPE= " + t.TranType.to_s
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 

  end
end
