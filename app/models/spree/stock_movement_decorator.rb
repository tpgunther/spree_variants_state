Spree::StockMovement.class_eval do
  after_create :check_no_active_variant

  def check_no_active_variant
    if stock_item.variant.product.all_variants_no_active?
      stock_item.variant.product.update(available_on: nil)
    end
  end
end
