class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
		
		dbh = RDBI.connect :ODBC, :db => "WHOLESALEPORTAL"

      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @products.first(10).each do |p|
        if p.Inactive == 0
          code = p.Code.strip
          description = p.Description.to_s.strip
          price1 = p.SalesPrice1
          price2 = p.SalesPrice2
          price3 = p.SalesPrice3
          price4 = p.SalesPrice4
          price5 = p.SalesPrice5
          rrp = p.SalesPrice6
          qty = p.QtyInStock
          qty = qty - p.QtyReserve
          if p.AllowDisc == 1
            allow_disc = true
          else
            allow_disc = false
          end
          group = p.ProductGroup.to_s.strip
          pricecat = p.PriceCat.to_s.strip
          puts pricecat
              # # needs category
              if Product.all.where(code: code).exists?
                #Product.all.find_by(code: code).update_attributes(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
                # filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                # filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                filename = "E:\\AttacheBI\\Resources\\ROC\\Images\\product\\1\\" + code + ".jpg"
                if File.exist?(filename)
			@results << filename
                  # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                else
			@results << "file doesn't exist for " + filename
                  #Product.all.find_by(code: code).destroy
                end
              else
		 @results << "product code doesn't exist in database, so create one"
                # newproduct = Product.new(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty, hidden: false)
                # filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                filename = "E:\\AttacheBI\\Resources\\ROC\\Images\\product\\1\\" + code + ".jpg"
                if File.exist?(filename)
			@results << filename
                  #Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                  #newproduct.save
		else
			@results << "file doesn't exist for " + filename
                end
                
              end
            else
              #destroy inactive
              code = p.Code.strip
              if thisprod = Product.all.find_by(code: code)
                #thisprod.destroy
              end
            end
          end

          dbh.disconnect
	
	
  end
end
