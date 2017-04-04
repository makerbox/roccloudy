class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	EmailJob.perform_async('web@roccloudy.com', Account.first)
  	AdminMailer.new_user_waiting_for_approval('web@roccloudy.com', Account.first).deliver_now
  end
end
