class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @products.each do |p|
        if p.Inactive == 0
          code = p.Code.strip
          description = p.Description.to_s.strip
          price1 = p.Salesprice1
          price2 = p.Salesprice2
          price3 = p.Salesprice3
          price4 = p.Salesprice4
          price5 = p.Salesprice5
          rrp = p.Salesprice6
          qty = p.Qtyinstock
          qty = qty - p.Qtyreserve
          if p.Allowdisc == 1
            allow_disc = true
          else
            allow_disc = false
          end
          group = p.Productgroup.to_s.strip
          pricecat = p.Pricecat.to_s.strip
          puts pricecat
              # # needs category
              if Product.all.where(code: code).exists?
                Product.all.find_by(code: code).update_attributes(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
                # filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                if File.exist?(filename)
                  Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                else
                  Product.all.find_by(code: code).destroy
                end
              else
                newproduct = Product.new(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty, hidden: false)
                filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                if File.exist?(filename)
                  Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                  newproduct.save
                end
                
              end
            else
              #destroy inactive
              code = p.code.strip
              if thisprod = Product.all.find_by(code: code)
                thisprod.destroy
              end
            end
          end

          dbh.disconnect
  end
end
