class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      thisorder.quantities.each do |q|
        if samsies = thisorder.quantities.where(product: q.product)
          newqty = samsies.sum(:qty)
          q.update(qty: newqty)
          mefirst = samsies.first
          if q.id != mefirst.id
            q.destroy
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
