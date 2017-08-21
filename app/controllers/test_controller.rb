class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       	@results = []


        Account.all.where('rep LIKE ? OR rep LIKE ?', '%SG%', '%SGW%').each do |a|
          @results << a.rep
          @results << a.company
        end
       	# dbh = RDBI.connect :ODBC, :db => "wholesaleportal"


      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      # @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      #     @products.first(100).each do |p|
      #       if p.Inactive == 0
      #         code = p.Code.strip
      #         # # needs category
      #         if Product.all.where(code: code).exists?
      #           # Product.all.find_by(code: code).update_attributes(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
      #           filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
      #           if File.exist?(filename)
      #             filedate = File.mtime(filename) #get date modified
      #             lastupdated = Product.all.find_by(code: code).updated_at
      #             timediff = lastupdated - filedate
      #             # if timediff <= 400 #update image if it's under a day old
      #               Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
      #             	@results << code
      #             # end
      #           end
      #         end
      #       end
      #     end

      #     dbh.disconnect

  	end
end