class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      dbh.execute("UPDATE contact_details_file SET EmailAddress = 'none-00' WHERE Code = 'WANDA EY'")
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
@results << 'updated WANDA EY in attache to have email none-00'
@results << 'now we need to run the seed, see if it worked, then copy to NZ'
      dbh.disconnect 

  end
end
