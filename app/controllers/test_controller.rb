class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            # if !User.all.find_by(email: contact.EmailAddress)
              email = contact.EmailAddress
              @results << email
            # end
          end
        end
      end
      dbh.disconnect 

  end
end
