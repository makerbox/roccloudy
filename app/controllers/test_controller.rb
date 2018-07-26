class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @products.each do |p|
      code = p.Code
      if Product.all.where(code: code).exists?
        @results << 'product exists'
        Product.all.find_by(code: code).update_attributes(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
        filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
        if File.exist?(filename)
          @results << 'image exists'
          # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          # stop from overloading transformations
        else
          @results << 'destroy when image not existent'
        end
        @results << filename
        @results << '-------------------------------'
      else
        'no such product'
        filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
        if File.exist?(filename)
          @results << 'image exists'
          # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          # stop from overloading transformations
          
        end
        @results << filename
        @results << '-------------------------------'
        
      end
    end
  end
end
