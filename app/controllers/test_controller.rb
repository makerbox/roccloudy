class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      thisorder = Order.find(368)
      unique_products = thisorder.products.uniq
      unique_products.each do |q|
        @results << q.code
        @results << q.id
        all_of_this = thisorder.products.where(code: q.code)
        qty = 0
        all_of_this.each do |c|
          # qty = qty + c.quantity.qty 
        end
        # @results << qty
      end


      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")


      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
