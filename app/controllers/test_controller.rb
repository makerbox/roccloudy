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
                  filedate = File.mtime(filename) 
                  @results << 'file updated >'
                  @results << filedate
                  @results << 'product updated >'
                  @results << Product.all.find_by(code: code).updated_at
                end
              end
            end
          end

          dbh.disconnect

  	end
end