json.extract! product, :id, :name, :brand, :category, :pricing_scheme, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
