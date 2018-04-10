class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
          @results << c.InDispute
        end
      end

      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")

      dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
