class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%A LA MOD%'").fetch(:all, :Struct)
      # transactions.last(15).each do |t|
      #   @results << "CODE= " + t.Code.to_s
      #   @results << "DATE= " + t.TranDate.to_s
      #   @results << "INVNUM= " + t.InvNum.to_s
      #   @results << "DOCNUM= " + t.DocNum.to_s
      #   @results << "TYPE= " + t.TranType.to_s
      #   @results << "REFERENCE= " + t.Refer.to_s
      #   @results << "AMOUNT= " + t.InvAmt.to_s
      #   @results << "DISC AMNT= " + t.DiscAmt.to_s
      #   @results << "COST= " + t.Cost.to_s
      #   @results << "REP= " + t.SalesRep.to_s
      #   @results << "TOTAL PAYMENT= " + t.TotalPayAmt.to_s
      #   @results << "COMMENT= " + t.Comment.to_s
      #   @results << "-----------------------------------------------"
      # end
      # dbh.disconnect 
      transactions = dbh.execute("SELECT * FROM invoice_hdextn WHERE InternalDocNum LIKE '%99344%'").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "Sub reference= " + t.SubRefNum.to_s
        @results << "WebRecNo= " + t.WebRecNo.to_s

        @results << "-----------------------------------------------"
      end
      dbh.disconnect 

  end
end
