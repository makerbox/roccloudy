class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    Order.find(368).quantities.each do |q|
        q.update(qty: 1)
      end
      Order.find(368).quantities.each do |q|
        newqty = q.order.quantities.where(product: q.product).sum(:qty)
        # q.order.quantities.where(product: q.product, id: !q).destroy
        q.update(qty: newqty)
        q.order.quantities.where(product: q.product).where.not(q).destroy_all
      end

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
