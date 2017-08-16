class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
       	@qty = []
       	@qtyhand = []

      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
          @products.each do |p|
            if p.Inactive == 0
              
              @qty << p.QtyInStock
              @qty << p.QtyReserve
              
          end
      end
      dbh.disconnect

  	end
end