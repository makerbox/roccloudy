class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      transactions = dbh.execute("SELECT * FROM product_transactions").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      transactions = dbh.execute("SELECT * FROM prodxfr_head").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 
      # transactions = dbh.execute("SELECT * FROM invdtlext").fetch(:all, :Struct)
      # transactions.last(15).each do |t|
      #   @results << "ORIGORDERREF= " + t.OrigOrderRef.to_s
      #   @results << "-----------------------------------------------"
      # end
      # dbh.disconnect 
      transactions = dbh.execute("SELECT * FROM invoice_header").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 
            transactions = dbh.execute("SELECT * FROM customer_transactions").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 
            transactions = dbh.execute("SELECT * FROM customer_std_charges").fetch(:all, :Struct)
      transactions.last(15).each do |t|
        @results << "REFERENCE= " + t.Refer.to_s
        @results << "-----------------------------------------------"
      end
      dbh.disconnect 

  end
end
