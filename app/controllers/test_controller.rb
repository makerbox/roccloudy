class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
      @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      dbh.execute("UPDATE contact_details_file SET EmailAddress = 'none' WHERE Code = 'WANDA EY'")
      dbh.disconnect

  end
end
