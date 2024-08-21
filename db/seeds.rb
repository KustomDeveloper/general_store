# db/seeds.rb

# First, let's clear existing products to avoid duplicates
Product.destroy_all

# Now, let's create some sample farmers market products
products = [
  {
    name: "Farm Fresh Eggs",
    description: "Dozen free-range, organic eggs",
    price: 4.99,
    stock: 50
  },
  {
    name: "Heirloom Tomatoes",
    description: "Mixed variety, organically grown (per lb)",
    price: 3.99,
    stock: 100
  },
  {
    name: "Local Honey",
    description: "Raw, unfiltered honey from local bees (16 oz jar)",
    price: 8.99,
    stock: 30
  },
  {
    name: "Organic Kale",
    description: "Freshly picked, crisp kale (per bunch)",
    price: 2.99,
    stock: 75
  },
  {
    name: "Artisan Sourdough Bread",
    description: "Freshly baked, traditional sourdough loaf",
    price: 6.99,
    stock: 25
  },
  {
    name: "Fresh Goat Cheese",
    description: "Creamy, tangy goat cheese (4 oz package)",
    price: 5.99,
    stock: 40
  },
  {
    name: "Organic Strawberries",
    description: "Sweet, juicy berries (1 pint basket)",
    price: 4.50,
    stock: 60
  },
  {
    name: "Farm-made Apple Butter",
    description: "Slow-cooked, spiced apple spread (8 oz jar)",
    price: 7.99,
    stock: 35
  },
  {
    name: "Fresh-cut Sunflowers",
    description: "Bright, cheerful bouquet (5 stems)",
    price: 9.99,
    stock: 20
  },
  {
    name: "Grass-fed Ground Beef",
    description: "Lean, locally raised beef (per lb)",
    price: 7.99,
    stock: 45
  }
]

# Create the products
products.each do |product|
  Product.create!(product)
end

puts "Created #{Product.count} farmers market products"