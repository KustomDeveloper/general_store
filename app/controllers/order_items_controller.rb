class OrderItemsController < ApplicationController
  def create
    Rails.logger.info "====== STARTING CREATE ORDER ITEM ======"
    @order = current_order
    @order_item = @order.order_items.find_or_initialize_by(product_id: params[:product_id])
    quantity_to_add = params[:quantity].to_i

    Rails.logger.info "Product ID: #{params[:product_id]}"
    Rails.logger.info "Quantity to add: #{quantity_to_add}"
    Rails.logger.info "Current Quantity: #{@order_item.quantity}"
    Rails.logger.info "Is new record? #{@order_item.new_record?}"

    if @order_item.new_record?
      @order_item.quantity = quantity_to_add
    else
      @order_item.quantity += quantity_to_add
    end

    @order_item.unit_price = @order_item.product.price
    @order_item.price = @order_item.product.price

    Rails.logger.info "Updated Quantity: #{@order_item.quantity}"
    Rails.logger.info "Product Price: #{@order_item.product.price}"
    Rails.logger.info "Order Item Unit Price: #{@order_item.unit_price}"
    Rails.logger.info "Order Item Price: #{@order_item.price}"

    ActiveRecord::Base.transaction do
      @order_item.save!
      @order.save!
    end

    session[:order_id] = @order.id
    flash[:notice] = "Item added to cart successfully."
    Rails.logger.info "Order saved successfully"
    Rails.logger.info "Final Quantity: #{@order_item.reload.quantity}"
    
    Rails.logger.info "====== ENDING CREATE ORDER ITEM ======"
    redirect_to cart_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Error adding item to cart: #{e.message}"
    Rails.logger.error "Order save failed: #{e.message}"
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