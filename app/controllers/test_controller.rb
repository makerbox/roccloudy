class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
      @results = []
		counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @results << 'count from Attache = ' + @customers.count
      @customers_ext.each do |ce|
        counter += 1
        code = ce.Code.strip
        if ce.InactiveCust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            @results << 'inactive in Attache' + account.code
          end
        else
          email = ce.EmailAddr.strip
          if !Account.all.find_by(code: code)
            if email.blank?
              email = counter
            end
            if !User.all.find_by(email: email)
              @results << email
            end
          end
        end
      end
      dbh.disconnect 


      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.Code.strip
        if Account.all.find_by(code: code)
        	@results << 'account exists ' + code
        end
      end
      dbh.disconnect 

  end
end