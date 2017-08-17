class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       	@results = []
       	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
       	# -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
          @products.each do |p|
            if p.Inactive == 0
              code = p.Code.strip
              if Product.all.where(code: code).exists?
                filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                if File.exist?(filename)
                  filedate = File.mtime(filename).to_date
                  productdate = Product.all.find_by(code: code).updated_at.to_date
                  qty = p.QtyInStock - p.QtyReserve
                  Product.all.find_by(code: code).update_attributes(qty: qty)
                  
                  		@results << 'PRODUCT'
                  		@results << code
	                  @results << 'file updated >'
	                  @results << filedate
	                  @results << 'product updated >'
	                  @results << productdate
	              	@results << '======'
	              	@results << filedate - productdate
                end
              end
            end
          end

          dbh.disconnect

  	end
end