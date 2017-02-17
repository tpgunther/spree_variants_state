Spree::Product.class_eval do

  def all_variants_no_active?
    variants.select(&:active?).none?
  end

  def any_variants_active?
    !all_variants_no_active?
  end
end
