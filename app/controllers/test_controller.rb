class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index 
    @results = []
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    @customers_ext.each do |ce|
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
      @results << ce.Code.strip
      @results << payterms
      @results << ce.TermsDays.to_s
      @results << '------------'
    end
    dbh.disconnect 

  end
end
