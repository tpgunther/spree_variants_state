Spree::Variant.class_eval do
  enum state: [:active, :descontinued, :discontinued] unless instance_methods.include? :state

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
    (discontinued? or descontinued?) and total_on_hand <= 0
  end
end
