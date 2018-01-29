class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      thisorder.quantities.each do |q|
        samsies = thisorder.quantities.where(product: q.product)
        newqty = samsies.sum(:qty)
        q.update(qty: newqty)
        # others = samsies.where.not(id: samsies.first.id)
        #   others.destroy_all
      end
      thisorder.quantities = thisorder.quantities.select(:product).distinct

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
