class PromotionEngine
  def initialize(cart_items)
    @cart_items = cart_items
  end

  def apply_promotions
    promotions = Promotion.where("start_time <= ? AND (end_time IS NULL OR end_time >= ?)", Time.current, Time.current)
    @cart_items.each do |cart_item|
      best_promotion = find_best_promotion(cart_item, promotions)
      apply_promotion(cart_item, best_promotion)
    end
  end

  private

  def find_best_promotion(cart_item, promotions)
    # This line filters applicable promotions
    applicable_promotions = promotions.select do |promo|
      promo_applies_to_item?(promo, cart_item.item)
    end
    # This line calculate the best discount
    applicable_promotions.max_by { |promo| calculate_discount(cart_item, promo) }
  end

  def promo_applies_to_item?(promo, item)
    promo.item_id == item.id || promo.category_id == item.category_id
  end

  def calculate_discount(cart_item, promo)
    case promo.promotion_type
    when "flat_fee"
      promo.discount_value
    when "percentage"
      cart_item.item.price * (promo.discount_value / 100.0)
    when "buy_x_get_y"
      if cart_item.quantity >= promo.x_quantity
        free_items = cart_item.quantity / promo.x_quantity
        free_items * promo.y_discount
      else
        0
      end
    when "weight_threshold"
      if cart_item.weight > promo.discount_value
        cart_item.item.price * (promo.y_discount / 100.0)
      else
        0
      end
    end
  end

  def apply_promotion(cart_item, promotion)
    return unless promotion

    discount = calculate_discount(cart_item, promotion)
    cart_item.update(price_applied: cart_item.item.price - discount, promotion_id: promotion.id)
  end
end
