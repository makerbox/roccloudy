class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE TranDate >= '#{(Date.today - 30.days).strftime('%Y-%m-%d')}'").fetch(:all, :Struct)

      transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%VALLEYGI%'").fetch(:all, :Struct)

      @results << transactions.count
      transactions.sort_by(&:TranDate)
      transactions.each do |t|
        @results << "CODE = " + t.Code.to_s
        @results << "TRANDATE = " + t.TranDate.to_s
        @results << "INVDATE = " + t.InvDate.to_s
        @results << "INVNUM = " + t.InvNum.to_s
        @results << "DOCNUM = " + t.DocNum.to_s
        @results << "REFERENCE = " + t.Refer.to_s
        @results << "TRANTYPE = " + t.TranType.to_s
        @results << "CAT = " + t.Cat.to_s
        @results << "INVAMT = " + t.InvAmt.to_s
        @results << "DISCAMT = " + t.DiscAmt.to_s
        @results << "MISCAMT = " + t.MiscAmt.to_s
        @results << "COST = " + t.Cost.to_s
        @results << "INVBAL = " + t.InvBal.to_s
        @results << "TOTAL CREDIT = " + t.TotalCredit.to_s
        @results << "TOTAL PAYMENT = " + t.TotalPayAmt.to_s
        @results << "TOTAL ADJUSTMENT = " + t.TotalAdjustAmt.to_s
        @results << "COMMENT = " + t.Comment.to_s
        @results << "ZERO BAL FLAG = " + t.ZeroBalFlag.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 


  end
end
