class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      
      product = Product.find_by(code: '7462E')
      prod_code = product.code
      prod_group = product.group
      prod_cat = product.pricecat
      @results = Discount.all.where('(product = ? AND (producttype = ? OR producttype = ?)) OR (product = ? AND (producttype = ? OR producttype = ?)) OR (product = ? AND (producttype = ? OR producttype = ?))', price_cat, 'cat_fixed', 'cat_percent' , prod_code , 'code_fixed', 'code_percent', prod_group, 'group_fixed', 'group_percent')
      # dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      # # @results = dbh.execute("INSERT INTO customer_master (Code, Name, Contact) VALUES ('test', 'test', 'test')")
      # # @results = dbh.execute("DELETE FROM customer_master WHERE Code = 'test'")

      # dbh.disconnect 
      # # redirect_to 'http://roccloudy.com'
  	end
end
