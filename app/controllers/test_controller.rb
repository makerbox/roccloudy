class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @products.each do |p|
      code = p.Code.strip
      if Product.all.where(code: code).exists?
        @results << 'product exists'
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
