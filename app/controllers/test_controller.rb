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
              qty = p.QtyInStock
              qty = qty - p.QtyReserve
              if Product.all.where(code: code).exists?
                filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                if File.exist?(filename)
                  filedate = File.mtime(filename) #get date modified
                  # Product.all.find_by(code: code).update_attribute(imageurl: filedate) #imageurl isn't used for anything, so use it to keep track of updates
                  # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                  if Product.all.find_by(code: code).updated_at <= filedate
                  	@results << filedate
                  end
                  @results << code
                  @results << qty
                # else
                  # Product.all.find_by(code: code).destroy
                end
              end
            end
          end

          dbh.disconnect

  	end
end