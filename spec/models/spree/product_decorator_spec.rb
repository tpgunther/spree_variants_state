# encoding: utf-8
require 'spec_helper'

RSpec.describe Spree::Variant, type: :model do
  let(:product) { FactoryGirl.create(:product) }

  before do
    product.variants << [FactoryGirl.create(:variant, :with_stock), FactoryGirl.create(:variant, :with_stock)]
  end

  context '#any_variants_active?' do
    it 'returns true if all variants are active' do
      product.variants.each { |v| expect(v.active?).to be true }
      expect(product.any_variants_active?).to be true
    end

    it 'returns true if one variants is active' do
      product.variants.first.update state: :discontinued
      product.variants.first.stock_items.first.set_count_on_hand 0

      expect(product.variants.first.no_active?).to be true
      expect(product.any_variants_active?).to be true
    end

    it 'returns false if no variants is active' do
      product.variants.each { |v| v.update state: :discontinued }
      product.variants.each { |v| v.stock_items.first.set_count_on_hand 0 }
      product.variants.each { |v| expect(v.no_active?).to be true }

      expect(product.any_variants_active?).to be false
    end
  end

  context '#all_variants_no_active?' do
    it 'returns false if all variants are active' do
      product.variants.each { |v| expect(v.active?).to be true }
      expect(product.all_variants_no_active?).to be false
    end

    it 'returns false if one variants is active' do
      product.variants.first.update state: :discontinued
      product.variants.first.stock_items.first.set_count_on_hand 0
      expect(product.variants.first.no_active?).to be true

      expect(product.all_variants_no_active?).to be false
    end

    it 'returns true if no variants is active' do
      product.variants.each { |v| v.update state: :discontinued }
      product.variants.each { |v| v.stock_items.first.set_count_on_hand 0 }
      product.variants.each { |v| expect(v.no_active?).to be true }

      expect(product.all_variants_no_active?).to be true
    end
  end
end
