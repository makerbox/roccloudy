class TestController < ApplicationController
      skip_before_action :authenticate_user!
      @results = Products.all

      

   
end
