Spree::Variant.class_eval do
  enum state: [:state_active, :state_descontinued, :state_discontinued] unless instance_methods.include? :state

  def state_name
    if no_active?
      I18n.t('activerecord.attributes.spree/product.no_active')
    elsif state.nil?
      I18n.t('activerecord.attributes.spree/product.active')
    else
      I18n.t("activerecord.attributes.spree/product.#{state}")
    end
  end

  def active?
    !no_active?
  end

  def no_active?
    (state_discontinued? or state_descontinued?) and total_on_hand <= 0
  end

  def check_no_active_product
    product.update(available_on: nil) if product.all_variants_no_active?
  end
end
