class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    @customers_ext.each do |ce|
      # case payterms
      # when '1'
      #   payterms = 'COD'
      # when '2'
      #   payterms = 'Set Day of Month'
      # when '3'
      #   payterms = 'Set Day of Next Month'
      # when '4'
      #   payterms = 'Day of Month after Next'
      # when '5'
      #   payterms = 'Number of Days'
      # when '6'
      #   payterms = 'Days after Month end'
      # end
      @results << ce.Code.strip
      @results << ce.PaymentTerms.to_s
      @results << ce.TermsDays.to_s
      @results << '------------'
    end
    dbh.disconnect 

  end
end
