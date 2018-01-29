class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      thisorder.quantities.each do |q|
        samsies = thisorder.quantities.where(product: q.product)
        newqty = samsies.sum(:qty)
        @results << 'SAMSIES = ' + samsies.count.to_s
        @results << 'NEWQTY = ' + newqty.to_s
        q.update(qty: newqty)
        others = samsies.where.not(id: samsies.first.id)
        others.destroy_all
      end

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
