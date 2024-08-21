class CartsController < ApplicationController
  def show
    @order_items = current_order.order_items
  end

  private

  def current_order
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.new
    end
  end
end