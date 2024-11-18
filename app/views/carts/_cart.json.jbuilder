json.extract! cart, :id, :subtotal, :discount, :total, :created_at, :updated_at
json.url cart_url(cart, format: :json)
