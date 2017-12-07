# app/jobs/order_email_job.rb
class OrderEmailJob
	include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(o)
  	  OrderMailer.order(o).deliver_now
  	  OrderMailer.receipt(o).deliver_now
  end

end