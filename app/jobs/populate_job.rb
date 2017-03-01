class PopulateJob
	include SuckerPunch::Job
 def perform
#THIS WILL COMPLETELY SEED THE DATABASE - ONLY RUN AT NIGHT
Contact.create(code:'running', email:'running')
@time = Time.now

    @results = []
    
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"


# -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    # Product.destroy_all
    @products.each do |p|
      if p.Inactive == 0
        code = p.Code.strip
        description = p.Description.to_s.strip
        price1 = p.SalesPrice1
        price2 = p.SalesPrice2
        price3 = p.SalesPrice3
        price4 = p.SalesPrice4
        price5 = p.SalesPrice5
        rrp = p.SalesPrice6
        qty = p.QtyInStock
        group = p.ProductGroup.to_s.strip
        pricecat = p.PriceCat.to_s.strip
        # # needs category
        if !Product.all.where(code: code).blank?
          Product.all.find_by(code: code).update_attributes(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
            # stop from overloading transformations
          else
            Product.all.find_by(code: code).destroy
          end
        else
          newproduct = Product.new(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          end
          newproduct.save
        end
      end
    end

    dbh.disconnect

#-------------------------UPDATE PRODUCTS WITH CATEGORIES -------------------------------------
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    @categories.each do |cat|
      if cat.CostCentre #if the prodmastext record has a category, then let's do it
        categorycode = cat.Code.strip
        if Product.find_by(code: categorycode) #if the product exists, let's give it the category (some products without images have no dice)
          Product.find_by(code: categorycode).update_attributes(category: cat.CostCentre.strip)
        end
      end
    end
dbh.disconnect

# ------------------------GET DATES AND UPDATE THE PRODUCTS WITH new_date FIELD-----------------------
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

    @datedata.each do |d|
      code = d.Code.strip
      if Product.find_by(code: code)
        Product.find_by(code: code).update_attributes(new_date: d.DateFld)
      end
    end

    dbh.disconnect


# ------------------------DISCOUNTS---------------------------------------------------------
    Discount.destroy_all #wipe existing discounts in case of some deletions in Attache
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

    def disco(percentage, fixed, fixedprice, level, maxqty, ctype, ptype, cust, prod)
      if fixedprice == 9 #if the discount is a fixed price
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
        Discount.create(customertype: customertype, producttype: producttype, customer: cust.strip, product: prod.strip, discount: discount, level: level, maxqty: maxqty)
    end

    discounts.each do |d|
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc1
        fixed = d.Price1
        fixedprice = d.PriceCode1
        level = 1
        maxqty = d.MaxQty1
      end
      if (d.PriceCode2 == 9) || (d.DiscCode2 == 9) 
        percentage = d.DiscPerc2
        fixed = d.Price2
        fixedprice = d.PriceCode2
        level = 2
        maxqty = d.MaxQty2
      end
      if (d.PriceCode3 == 9) || (d.DiscCode3 == 9) 
        percentage = d.DiscPerc3
        fixed = d.Price3
        fixedprice = d.PriceCode3
        level = 3
        maxqty = d.MaxQty3
      end
      if (d.PriceCode4 == 9) || (d.DiscCode4 == 9) 
        percentage = d.DiscPerc4
        fixed = d.Price4
        fixedprice = d.PriceCode4
        level = 4
        maxqty = d.MaxQty4
      end
      if (d.PriceCode5 == 9) || (d.DiscCode5 == 9) 
        percentage = d.DiscPerc5
        fixed = d.Price5
        fixedprice = d.PriceCode5
        level = 5
        maxqty = d.MaxQty5
      end
      if (d.PriceCode6 == 9) || (d.DiscCode6 == 9) 
        percentage = d.DiscPerc6
        fixed = d.Price6
        fixedprice = d.PriceCode6
        level = 6
        maxqty = d.MaxQty6
      end
      if (d.PriceCode7 == 9) || (d.DiscCode7 == 9) 
        percentage = d.DiscPerc7
        fixed = d.Price7
        fixedprice = d.PriceCode7
        level = 7
        maxqty = d.MaxQty7
      end
      if (d.PriceCode8 == 9) || (d.DiscCode8 == 9) 
        percentage = d.DiscPerc8
        fixed = d.Price8
        fixedprice = d.PriceCode8
        level = 8
        maxqty = d.MaxQty8
      end
      if (d.PriceCode9 == 9) || (d.DiscCode9 == 9) 
        percentage = d.DiscPerc9
        fixed = d.Price9
        fixedprice = d.PriceCode9
        level = 9
        maxqty = d.MaxQty9
      end
      if (d.PriceCode10 == 9) || (d.DiscCode10 == 9) 
        percentage = d.DiscPerc10
        fixed = d.Price10
        fixedprice = d.PriceCode10
        level = 10
        maxqty = d.MaxQty10
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
      end
    end

    dbh.disconnect   

# ------------------------META DATA--------------------------------------------------------------
    @results << Product.count
    @time = (Time.now - @time) / 60
    Contact.where(code:'running').each do |del|
        del.destroy
    end

end #end perform

end #end class