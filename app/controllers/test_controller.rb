class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM customer_gl_interface").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE = " + t.Refer.to_s
        @results << "CODE = " + t.Code.to_s
        @results << "DATE = " + t.Date.to_s
        @results << "AMT = " + t.Amt.to_s
        @results << "CUSTOMER = " + t.Customer.to_s
        @results << "DETAILS = " + t.Detail.to_s
        @results << "-----------------------------------------------"
      end
      
      dbh.disconnect 

  end
end
