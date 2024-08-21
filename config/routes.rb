Rails.application.routes.draw do
  get 'order_items/create'
  get 'order_items/update'
  get 'order_items/destroy'
  get 'carts/show'
  get 'products/index'
  get 'products/show'
  root 'products#index'
  
  resources :products, only: [:index, :show]
  resources :order_items, only: [:create, :update, :destroy]
  get 'cart', to: 'carts#show'
end
