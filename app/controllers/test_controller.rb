class TestController < ApplicationController
      skip_before_action :authenticate_user!
      def index
            
      @results = Product.all
            
            
      end
end
