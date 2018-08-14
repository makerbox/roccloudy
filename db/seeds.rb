# Contact.create(code:'clock', email:'start')
# Contact.create(code:'running', email:'running')

puts 'RUNNING SEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEED'
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      # -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @products.each do |p|
        if p.inactive == 0
          code = p.code.strip
          description = p.description.to_s.strip
          price1 = p.salesprice1
          price2 = p.salesprice2
          price3 = p.salesprice3
          price4 = p.salesprice4
          price5 = p.salesprice5
          rrp = p.salesprice6
          qty = p.qtyinstock
          qty = qty - p.qtyreserve
          if p.allowdisc == 1
            allow_disc = true
          else
            allow_disc = false
          end
          group = p.productgroup.to_s.strip
          pricecat = p.pricecat.to_s.strip
          puts pricecat
              # # needs category
              if Product.all.where(code: code).exists?
                Product.all.find_by(code: code).update_attributes(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
                # filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                if File.exist?(filename)
                  Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                else
                  Product.all.find_by(code: code).destroy
                end
              else
                newproduct = Product.new(allow_disc: allow_disc, pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty, hidden: false)
                filename = "Z:\\AttacheBI\\Resources\\ROC\\images\\Product\\1\\" + code + ".jpg"
                if File.exist?(filename)
                  Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                  newproduct.save
                end
                
              end
            else
              #destroy inactive
              code = p.code.strip
              if thisprod = Product.all.find_by(code: code)
                thisprod.destroy
              end
            end
          end

          dbh.disconnect

      #-------------------------UPDATE PRODUCTS WITH CATEGORIES -------------------------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
      @categories.each do |cat|
            if cat.costcentre #if the prodmastext record has a category, then let's do it
              categorycode = cat.code.strip
              if Product.find_by(code: categorycode) #if the product exists, let's give it the category (some products without images have no dice)
                Product.find_by(code: categorycode).update_attributes(category: cat.costcentre.strip)
              end
            end
          end
          dbh.disconnect

      #------------------------GET DATES AND UPDATE THE PRODUCTS WITH new_date FIELD-----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

      @datedata.each do |d|
        code = d.Code.strip
        if Product.find_by(code: code)
          Product.find_by(code: code).update_attributes(new_date: d.datefld)
        end
      end

      dbh.disconnect

      # ------------------------GET FABS, CONNECT THEM, AND UPDATE THE PRODUCTS-----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      @fabdata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
      fab = ''
      @fabdata.each do |d|
        code = d.code.strip
        if Product.find_by(code: code)
          if !d.textfld.blank?
            fab = d.textfld.strip
            Product.find_by(code: code).update_attributes(fab: fab)
          end
        end
      end

      dbh.disconnect

      # ------------------------DISCOUNTS---------------------------------------------------------
       Discount.destroy_all #wipe existing discounts in case of some deletions in Attache
       dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
       discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

       def disco(percentage, fixed, fixedprice, level, maxqty, ctype, ptype, cust, prod)
            if fixedprice == 9 #if the discount is a fixed price
              disctype = 'fixedtype'
              discount = fixed
              if ctype == 10
                customertype = 'code_fixed'
              else
                customertype = 'group_fixed'
              end
              if ptype == 10
                producttype = 'code_fixed'
              elsif ptype == 30
                producttype = 'group_fixed'
              else
                producttype = 'cat_fixed'
              end
            else
              disctype = 'percentagetype'
              discount = percentage
              if ctype == 10
                customertype = 'code_percent'
              else
                customertype = 'group_percent'
              end
              if ptype == 10
                producttype = 'code_percent'
              elsif ptype == 30
                producttype = 'group_percent'
              else
                producttype = 'cat_percent'
              end
            end
            if maxqty #sometimes there is no qty
              if maxqty >= 10000 #sometimes it's way too big to store as an integer
                maxqty = 9999
              end
            end
            if !prod.nil? && !cust.nil?
              puts 'DISCOUNT------------------------------'
              puts cust.strip
              discount = sprintf("%.2f", discount)
              puts discount
              Discount.create(customertype: customertype, producttype: producttype, customer: cust.strip, product: prod.strip, discount: discount, level: level, maxqty: maxqty, disctype: disctype)
            end

          end

          discounts.each do |d|
            if (d.levelnum >= 1) 
              percentage = d.discperc1
              fixed = d.price1
              fixedprice = d.pricecode1
              level = 1
              maxqty = d.maxqty1
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
            if (d.levelnum >= 2) 
              percentage = d.discperc2
              fixed = d.price2
              fixedprice = d.pricecode2
              level = 2
              maxqty = d.maxqty2
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
            if (d.LevelNum >= 3) 
              percentage = d.discperc3
              fixed = d.price3
              fixedprice = d.pricecode3
              level = 3
              maxqty = d.maxqty3
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
            if (d.levelnum >= 4) 
              percentage = d.discperc4
              fixed = d.price4
              fixedprice = d.pricecode4
              level = 4
              maxqty = d.maxqty4
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
            if (d.levelnum >= 5) 
              percentage = d.discperc5
              fixed = d.price5
              fixedprice = d.pricecode5
              level = 5
              maxqty = d.maxqty5
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
            if (d.levelnum >= 6) 
              percentage = d.discperc6
              fixed = d.price6
              fixedprice = d.pricecode6
              level = 6
              maxqty = d.maxqty6
              disco(percentage, fixed, fixedprice, level, maxqty, d.customertype, d.producttype, d.customer, d.product)
            end
          end

          dbh.disconnect 

      # -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

      counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        code = ce.code.strip
        if ce.inactivecust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            user = account.user
            account.destroy
            user.destroy
          end
        else
          payterms = ce.paymentterms.to_s
          case payterms
          when '1'
            payterms = 'COD'
          when '2'
            payterms = 'Set Day of Month (' + ce.termsdays.to_s + ')'
          when '3'
            payterms = 'Set Day of Next Month (' + ce.termsdays.to_s + ')'
          when '4'
            payterms = 'Day of Month after Next (' + ce.termsdays.to_s + ')'
          when '5'
            payterms = ce.termsdays.to_s + ' Days'
          when '6'
            payterms =  ce.termsdays.to_s + 'Days after Month end'
          end
          if !ce.emailaddr.blank?
            email = ce.emailaddr.downcase.strip
          end
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


      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
      @customers.each do |c|
        code = c.code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
          if c.indispute == 1
            dispute = true
          else
            dispute = false
          end
          compname = c.name
          street = c.street
          suburb = c.suburb 
          state = c.territory
          postcode = c.postcode 
          phone = c.phone 
          sort = c.sort 
          discount = c.specialpricecat 
          seller_level = c.pricecat
          rep = c.salesrep
          account.update_attributes(approved: 'approved', phone: phone, street: street, state: state, suburb: suburb, postcode: postcode, sort: sort, company: compname, rep: rep, seller_level: seller_level, discount: discount)
        end
      end
      dbh.disconnect 

      # --------------------- ADD EMAIL ADDRESSES ----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            if email = contact.emailaddress
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

      #------------------------- SET DEFAULT SELLER LEVEL ---------------------
      unset = Account.all.where(seller_level: nil)
      unset.each do |acct|
        acct.update_attributes(seller_level: '1')
      end


      #-------------------------- CREATE ADMIN USER -------------------------------------

      def createadmin(adminemail, admincode)
        if adminuser = User.all.find_by(email: adminemail)
          adminuser.add_role :admin
          adminuser.remove_role :user
          if adminuser.account
            adminuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
          else
            Account.create(code: admincode, company: 'Roc', user: adminuser, sort: 'U/L/R/P')
          end
        else
          adminuser = User.new(email: adminemail, password:'1023@Ralph', password_confirmation: '1023@Ralph')
          adminuser.add_role :admin
          adminuser.save(validate: false)
          Account.create(code: admincode, company: 'Roc', user: adminuser, sort: 'U/L/R/P')
        end
      end
      createadmin('web@roccloudy.com', 'ADMIN')
      createadmin('office@roccloudy.com', 'OFFICE')

      #-------------------------- CREATE REP ACCOUNTS -----------------------------------
      def createrep(repemail, repcode)
        if repuser = User.all.find_by(email: repemail)
          repuser.add_role :rep
          repuser.remove_role :user
          if repuser.account
            repuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
          else
            Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
          end
        else
          repuser = User.new(email: repemail, password:'1023@Ralph', password_confirmation: '1023@Ralph')
          repuser.add_role :rep
          repuser.save(validate: false)
          Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
        end
      end

      createrep('nsw@roccloudy.com', 'REPNSW')
      createrep('vic@roccloudy.com', 'REPVIC')
      createrep('qld1@roccloudy.com', 'REPQLD1')
      # createrep('qld2@roccloudy.com', 'REPQLD2')
      createrep('nz@roccloudy.com', 'REPNZ')
      createrep('office@roccloudy.com', 'ADMINOFFICE')

      # CODE FOR HEROKU CONSOLE TO EDIT ADMIN AND REP PASSWORDS
      # -----------------------------------
      # REP PASSWORDS
      # -------------
      # def editrep(repemail)
      #   repuser = User.all.find_by(email: repemail)
      #   repuser.update_attributes(password:'1023@Ralph', password_confirmation: '1023@Ralph')
      # end
      # editrep('nsw@roccloudy.com')
      # editrep('vic@roccloudy.com')
      # editrep('qld1@roccloudy.com')
      # editrep('nz@roccloudy.com')
      # editrep('office@roccloudy.com')
      # ----------------------------------
      # ADMIN PASSWORDS
      # -------------
      # def editadmin(adminemail)
      #   adminuser = User.all.find_by(email: adminemail)
      #   adminuser.update_attributes(password:'1023@Ralph', password_confirmation: '1023@Ralph')
      # end
      # editadmin('web@roccloudy.com')
      # editadmin('office@roccloudy.com')

# ----------------update credit report for each account -------------
  dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
  customer = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
  customer.each do |t|
    if account = Account.find_by(code: t.code.strip)
      account.update(current: t.currentbal, days30: t.period1bal, days60: t.period2bal, days90: t.period3bal)
    end
  end
  dbh.disconnect 


# ---------------destroy all old quantities ---------------
# Quantity.all.where('created_at <= ?', (Date.today - 30.days)).destroy
# ---------------destroy all old, unsent orders ---------------
Order.all.where(sent: nil).where('created_at <= ?', (Date.today - 30.days)).destroy_all
      # ------------------------META DATA--------------------------------------------------------------

      