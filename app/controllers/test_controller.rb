class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       	@lastdiscount = Discount.all.last
       	@results = []
       	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"


      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      	@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
          @products.each do |p|
            if p.Inactive == 0
              @code = p.Code.strip
              @qty = p.QtyInStock
              @rqty = p.QtyReserved
              @onhand = @qty - @rqty
              @group = p.ProductGroup.to_s.strip
              @pricecat = p.PriceCat.to_s.strip
              @results << @code
              @results << @qty
              @results << @rqty
              @results << @onhand
              @results << @group
              @results << @pricecat
          	end
          end

    	dbh.disconnect
  	end
end