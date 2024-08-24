class OrderItemsController < ApplicationController
  def create
    Rails.logger.info "====== STARTING CREATE ORDER ITEM ======"
    Rails.logger.info "Params: #{params.inspect}"
    
    @order = current_order
    product_id = params[:product_id] || (params[:order_item] && params[:order_item][:product_id])
    quantity = params[:quantity] || (params[:order_item] && params[:order_item][:quantity]) || 1

    Rails.logger.info "Product ID: #{product_id}"
    Rails.logger.info "Quantity to add: #{quantity}"

    if product_id.nil?
      Rails.logger.error "Product ID is nil"
      flash[:alert] = "Error: Product not specified."
      redirect_to root_path and return
    end

    product = Product.find_by(id: product_id)
    if product.nil?
      Rails.logger.error "Product not found for ID: #{product_id}"
      flash[:alert] = "Product not found."
      redirect_to root_path and return
    end

    @order_item = @order.order_items.find_or_initialize_by(product_id: product_id)
    
    Rails.logger.info "Current Quantity: #{@order_item.quantity}"
    Rails.logger.info "Is new record? #{@order_item.new_record?}"

    new_quantity = @order_item.new_record? ? quantity.to_i : @order_item.quantity + quantity.to_i

    # Check if the new quantity exceeds available stock
    if new_quantity > product.stock
      Rails.logger.error "Requested quantity (#{new_quantity}) exceeds available stock (#{product.stock})"
      flash[:alert] = "Sorry, we don't have enough stock. Available: #{product.stock}"
      redirect_to product_path(product) and return
    end

    @order_item.quantity = new_quantity
    @order_item.unit_price = product.price
    @order_item.price = product.price

    Rails.logger.info "Updated Quantity: #{@order_item.quantity}"
    Rails.logger.info "Product Price: #{product.price}"
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
    new_quantity = order_item_params[:quantity].to_i

    # Check if the new quantity exceeds available stock
    if new_quantity > @order_item.product.stock
      flash[:alert] = "Sorry, we don't have enough stock. Available: #{@order_item.product.stock}"
    else
      @order_item.update(order_item_params)
      flash[:notice] = "Cart updated successfully."
    end

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