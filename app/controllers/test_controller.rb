class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE TranDate >= '#{(Date.today - 30.days).strftime('%Y-%m-%d')}'").fetch(:all, :Struct)
      # transactions = dbh.execute("SELECT * FROM customer_transactions WHERE Code LIKE '%VALLEYGI%'").fetch(:all, :Struct)

      customer = dbh.execute("SELECT * FROM customer_master WHERE Code LIKE '%VALLEYGI%'").fetch(:all, :Struct)

      customer.each do |t|
        @results << "CODE = " + t.Code.to_s
        @results << "PERIOD 1 BALANCE = " + t.Period1Bal.to_s
        @results << "PERIOD 2 BALANCE = " + t.Period2Bal.to_s
        @results << "PERIOD 3 BALANCE = " + t.Period3Bal.to_s
        @results << "CURRENT BALANCE = " + t.CurrentBal.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 


  end
end
