Spree::Variant.class_eval do
  enum state: [:state_active, :state_descontinued, :state_discontinued] unless instance_methods.include? :state

  scope :not_discontinued_or_descontinued, ->  { where('state IS NULL OR state = ?', :state_active) }

  def state_name
    if no_active?
      I18n.t('activerecord.attributes.spree/product.no_active')
    elsif state.nil?
      I18n.t('activerecord.attributes.spree/product.state_active')
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
    update(disable: true) if no_active?
    product.update(available_on: nil) if product.all_variants_no_active?
  end
end
