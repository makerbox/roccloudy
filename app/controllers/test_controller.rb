class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    # -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

      counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        code = ce.Code.strip
        if code == 'SHIMMERS'
          @results << code
        end
      end
      dbh.disconnect 


  end
end
