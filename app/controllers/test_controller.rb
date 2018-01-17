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
          @prodords = dbh.execute("SELECT * FROM purch_order_detail WHERE TranType = 30").fetch(1, :Struct)
          @prodords.each do |p|
            @header = dbh.execute("SELECT * FROM purch_order_header WHERE DocNumPOHdr = '#{p.DocNum}'").fetch(:all, :Struct)
            @header.each do |h|
              h.TranType
              h.Name
            end
          end
          dbh.disconnect

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
