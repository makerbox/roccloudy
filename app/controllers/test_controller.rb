class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
    @results = []
          if params[:order]
            @results << params[:order]
          else
            @results << 'no params'
          end
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          @results << dbh.execute("SELECT * FROM invoice_header").fetch(:last, :Struct)
          @results << dbh.execute("SELECT * FROM invoice_hdextn").fetch(:last, :Struct)
          @results << dbh.execute("SELECT * FROM invoice_hdext2").fetch(:last, :Struct)
          @results << dbh.execute("SELECT * FROM invoice_detail").fetch(:last, :Struct)
          
          dbh.disconnect

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
