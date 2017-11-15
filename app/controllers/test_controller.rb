class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		@products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)

		@results = []
		@products.each do |p|
			if p.Inactive == 0
				@results << p.Code
				@results << '= inactive?'
				@results << p.Inactive
				@results << '............'
			end
		end


		dbh.disconnect
  end
end