class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        code = ce.Code.strip
        if ce.InactiveCust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            user = account.user
            account.destroy
            user.destroy
          end
        else
          email = ce.EmailAddr
          if !(myAcct = Account.all.find_by(code: code))
            @results << 'no account'
          else
            myAcct.user.update(email: email)
            @results << email
            @results << 'account found'
          end
        end
      end
      dbh.disconnect 

  end
end
