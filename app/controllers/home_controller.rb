class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      redirect_to :back
  end

  def seed
    system "rake db:seed"
    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
   @test = Product.all
   @test.each do |p|
      if !p.category.nil?
        cat = p.category.strip
        p.update(category: cat)
      end
    end
  end

end
