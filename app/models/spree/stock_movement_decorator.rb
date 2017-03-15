Spree::StockMovement.class_eval do
  after_create :check_no_active_variant

  def check_no_active_variant
    CheckNotActiveVariantsWorker.perform_async(stock_item.variant.id)
  end
end
