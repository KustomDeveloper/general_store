class OrderItemsController < ApplicationController
  def create
    @order = current_order
    @order_item = @order.order_items.find_or_create_by(product_id: params[:product_id]) do |item|
      item.quantity = 0
      item.unit_price = item.product.price
      item.price = item.product.price
    end

    @order_item.quantity += 1
    
    puts "Debug: Product ID: #{params[:product_id]}"
    puts "Debug: Product Price: #{@order_item.product.price}"
    puts "Debug: Order Item Unit Price: #{@order_item.unit_price}"
    puts "Debug: Order Item Price: #{@order_item.price}"
    puts "Debug: Order Item Quantity: #{@order_item.quantity}"
    
    if @order.save
      session[:order_id] = @order.id
      flash[:notice] = "Item added to cart successfully."
    else
      flash[:alert] = "Error adding item to cart: #{@order.errors.full_messages.join(", ")}"
      puts "Order save failed: #{@order.errors.full_messages}"
      puts "Order item errors: #{@order_item.errors.full_messages}"
    end
    
    redirect_to cart_path
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update(order_item_params)
    @order_items = @order.order_items
    redirect_to cart_path
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
    redirect_to cart_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

  def current_order
    Order.find_or_create_by(id: session[:order_id])
  end
end