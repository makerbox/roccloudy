class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    # -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

      counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        code = ce.Code.strip
        if ce.InactiveCust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            user = account.user
            account.destroy
            user.destroy
          end
        else
          payterms = ce.PaymentTerms.to_s
          case payterms
          when '1'
            payterms = 'COD'
          when '2'
            payterms = 'Set Day of Month (' + ce.TermsDays.to_s + ')'
          when '3'
            payterms = 'Set Day of Next Month (' + ce.TermsDays.to_s + ')'
          when '4'
            payterms = 'Day of Month after Next (' + ce.TermsDays.to_s + ')'
          when '5'
            payterms = ce.TermsDays.to_s + ' Days'
          when '6'
            payterms =  ce.TermsDays.to_s + 'Days after Month end'
          end
          email = ce.EmailAddr.downcase
          if !Account.all.find_by(code: code)
            if email.blank?
              email = counter
            end
            if !User.all.find_by(email: email)
              newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
              if newuser.save(validate: false) #false to skip validation
                newuser.add_role :user
                newaccount = Account.new(payterms: payterms, code: code, user: newuser) #create the account and associate with user
                newaccount.save
              end
            end
          else
            Account.all.find_by(code: code).update(payterms: payterms)
            Account.all.find_by(code: code).user.update(email: email)
          end
        end
      end
      dbh.disconnect 
      # --------------------- ADD EMAIL ADDRESSES ----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            if email = contact.EmailAddress
              email = email.strip.downcase
              if !User.all.find_by(email: email)
                thisuser = account.user
                thisuser.email = email.strip
                thisuser.save(validate: false)
              end
            end
          end
        end
      end
      dbh.disconnect 


  end
end
