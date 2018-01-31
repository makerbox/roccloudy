class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      unique_products = thisorder.products.uniq
      unique_products.each do |q|
        newqty = thisorder.quantities.where(product: q).sum(:qty)
        original = thisorder.quantities.where(product: q).first
        original.update(qty: newqty)
        thisorder.quantities.where.not(original).each do |d|
          @results << d.qty
        end
      end


      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
