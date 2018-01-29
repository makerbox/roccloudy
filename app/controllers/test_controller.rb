class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      Order.find(368).quantities.each do |q|
        if q.order.quantities.where(product: q.product).count > 1
          q.order.quantities.where(product: q.product, id: !q.id).each do |samo|
            q.update(qty: (samo.qty + q.qty))
            samo.destroy
          end
        end
      end

      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
