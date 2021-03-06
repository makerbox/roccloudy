class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :sendorder, :kfime]
  skip_before_action :authenticate_user!, only: [:kfime]
  def sendorder
    # collate duplicate products
    unique_products = @order.products.uniq
    unique_products.each do |q|
      these_quantities = @order.quantities.where(product_id: q.id)
      newqty = these_quantities.sum(:qty)
      original = these_quantities.first
      original.update(qty: newqty)
      these_quantities.all.where.not(id: original.id).destroy_all
    end
    total = 0
    @order.quantities.each do |q| # change stock levels and calc order total
      oldqty = q.product.qty
      newqty = oldqty - q.qty
      q.product.update(qty: newqty)
      total = total + (q.qty * q.price)
    end
    sent = DateTime.now
    @order.update(active: false, sent: sent, total: total) # move order to pending and give it a total
    
    @account = @order.user.account
    OrderEmailJob.perform_async(@order)

    if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic)
      current_user.mimic.destroy
    end

    redirect_to "http://203.217.18.253:3200/orders/#{@order.id}/kfime"
    # redirect_to "http://wholesale.roccloudy.com/home/confirm"
  end

def kfime
  @order.kfi
  redirect_to "http://wholesale.roccloudy.com/home/confirm"
end
# def cart #if there aren't any active orders, then create one
#   product = Product.find_by(id: params[:product])
#   order = Order.create(user: current_user, active: true)
#   qty = params[:qty]
#   ProductOrder.create(order: order, product: product, qty: qty)
#   redirect_to product, notice: 'successfully added to order'
# end

# def addto
#   product = Product.find_by(id: params[:product])
#   order = current_user.orders.where(active: true).last
#   qty = params[:qty]
#   ProductOrder.create(order: order, product: product, qty: qty)
#   redirect_to product, notice: 'successfully added to order'
# end

  # GET /orders
  # GET /orders.json
  def index
    # partial is being rendered in Account view, so moved to Account controller
    # this stuff is for the main index that only admin can see
    if user_signed_in?
      if (current_user.has_role? :admin)
        @orders = Order.all.order(sent: :desc, created_at: :desc)
        @orders = @orders.paginate(:page => params[:page], :per_page => 20)
      else
        redirect_to home_index_path
      end
    else
      redirect_to home_index_path
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @sellerlevel = @order.user.account.seller_level

    if params[:showcart] == 'show'
          if user_signed_in?
      if ((current_user.has_role? :admin) || (current_user.has_role? :rep)) && (current_user.mimic) #for sidecart
        @order = current_user.mimic.account.user.orders.where(active: true).last #for sidecart
      else #for sidecart
        @order = current_user.orders.where(active: true).last #for sidecart
      end #for sidecart
    end
        @showbuttons = 'show'
      else
        @showbuttons = 'noshow'
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    # if (current_user.has_role? :admin) || (current_user.has_role? :rep)
    #   @order.order_number = current_user.account.code + Order.all.count.to_s
    # else
    #   @order.order_number = Order.all.count.to_s
    # end
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order.quantities.last.product, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to home_index_path, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel_order
    Order.find(params[:id]).quantities.all.destroy_all
    redirect_to home_index_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:showcart, :total, :user_id, :notes, :cust_order_number, :order_number, :delivery_date)
    end
  end
