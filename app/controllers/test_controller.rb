class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      unique_products = thisorder.products.uniq
      unique_products.each do |q|
        these_quantities = thisorder.quantities.where(product_id: q.id)
        newqty = these_quantities.sum(:qty)
        original = these_quantities.first
        @results << original
        original.update(qty: newqty)
        these_quantities.all.where.not(id: original.id).destroy_all
      end


      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
