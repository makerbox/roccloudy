class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE TranDate >= '#{(Date.today - 30.days).strftime('%Y-%m-%d')}'").fetch(:all, :Struct)
      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%VALLEYGI%'").fetch(:all, :Struct)

      customer = dbh.execute("SELECT * FROM customer_master WHERE Code LIKE '%HAVANA%'").fetch(:all, :Struct)

      customer.each do |t|
        @results << "CURRENT = " + t.CurrentBal.to_s
        @results << "30 = " + t.Period1Bal.to_s
        @results << "60 = " + t.Period2Bal.to_s
        @results << "90 = " + t.Period3Bal.to_s
        @results << "UNALLOCATED = " + t.UnallocBal.to_s
        @results << "POST DATED = " + t.PostDateBal.to_s
        @results << "TOTAL OUTSTANDING = " + (t.CurrentBal + t.Period1Bal + t.Period2Bal + t.Period3Bal).to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 


  end
end
