# encoding: utf-8
require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Spree::Product, type: :model do
  let(:product) { FactoryGirl.create(:product) }

  before do
    product.variants << [FactoryGirl.create(:variant, :with_stock), FactoryGirl.create(:variant, :with_stock)]
    Sidekiq::Testing.inline!
  end

  context '#any_variants_active?' do
    it 'returns true if all variants are active' do
      product.variants.each { |v| expect(v.active?).to be true }
      expect(product.any_variants_active?).to be true
    end

    it 'returns true if one variants is active' do
      product.variants[0].update state: :state_discontinued
      FactoryGirl.create(:stock_movement, stock_item: product.variants[0].stock_items[0], quantity: -1 * product.variants[0].total_on_hand)

      expect(product.variants[0].reload.no_active?).to be true
      expect(product.variants[0].reload.disable?).to be true
      expect(product.reload.any_variants_active?).to be true
    end

    it 'returns false if no variants is active' do
      product.variants.each { |v| v.update state: :state_discontinued }
      product.variants.each { |v| FactoryGirl.create(:stock_movement, stock_item: v.stock_items[0], quantity: -1 * v.total_on_hand) }
      product.variants.each { |v| expect(v.reload.no_active?).to be true }
      product.variants.each { |v| expect(v.reload.disable?).to be true }

      expect(product.reload.any_variants_active?).to be false
    end
  end

  context '#all_variants_no_active?' do
    it 'returns false if all variants are active' do
      product.variants.each { |v| expect(v.active?).to be true }
      expect(product.all_variants_no_active?).to be false
    end

    it 'returns false if one variants is active' do
      product.variants[0].update state: :state_discontinued
      FactoryGirl.create(:stock_movement, stock_item: product.variants[0].stock_items[0], quantity: -1 * product.variants[0].total_on_hand)
      expect(product.variants[0].reload.no_active?).to be true
      expect(product.variants[0].reload.disable?).to be true

      expect(product.reload.all_variants_no_active?).to be false
    end

    it 'returns true if no variants is active' do
      product.variants.each { |v| v.update state: :state_discontinued }
      product.variants.each { |v| FactoryGirl.create(:stock_movement, stock_item: v.stock_items[0], quantity: -1 * v.total_on_hand) }
      product.variants.each { |v| expect(v.reload.no_active?).to be true }
      product.variants.each { |v| expect(v.reload.disable).to be true }

      expect(product.reload.all_variants_no_active?).to be true
    end
  end
end
