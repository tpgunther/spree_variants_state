FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_variant_state/factories'


end


FactoryGirl.modify do
  factory :base_variant do
    trait :with_stock do
      transient do
        stock 10
      end

      after(:create) do |variant, evaluator|
        stock_location = variant.stock_locations.first
        stock_movement = stock_location.stock_movements.build(quantity: evaluator.stock)
        stock_movement.stock_item = stock_location.set_up_stock_item(variant.id)
        stock_movement.save
        variant.stock_items.last.update backorderable: false
      end
    end
  end
end
