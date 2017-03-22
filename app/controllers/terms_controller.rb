class TermsController < ApplicationController
	skip_before_action :authenticate_user!
	def index
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
	@customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
@results = []
    @customers.each do |c|
      code = c.Code
      compname = c.Name
      street = c.Street
      suburb = c.Suburb 
      postcode = c.Postcode 
      phone = c.Phone 
      sort = c.Sort 
      discount = c.SpecialPriceCat 
      seller_level = c.PriceCat

      # code
      # name
      # street
      # suburb
      # postcode
      # phone
      # Contact
      # sort
      # territory
      # SalesRep
      # cat
      # PriceCat
      # specialpricecat
      # (camelcase)
      if Account.all.find_by(code: code).any?
        @results << code
      end
    end
    dbh.disconnect
  end #end def index

end #end class
