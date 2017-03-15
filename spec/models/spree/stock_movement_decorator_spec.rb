# encoding: utf-8
require 'spec_helper'
require 'sidekiq/testing'

RSpec.describe Spree::StockMovement, type: :model do
  let(:variant) { FactoryGirl.create(:variant, :with_stock, product: FactoryGirl.create(:product, available_on: 1.day.ago), state: :state_discontinued) }

  before do
    Sidekiq::Testing.inline!
  end

  it 'product is available' do
    expect(variant.active?).to be true
  end

  context '#check_no_active_variant' do
    context 'with one variant' do
      context 'when stock is 0' do
        it 'product is not available' do
          FactoryGirl.create(:stock_movement, stock_item: variant.stock_items[0], quantity: -1 * variant.total_on_hand)

          expect(variant.reload.product.available_on).to be nil
          expect(variant.reload.active?).to be false
        end
      end
    end

    context 'with more variants' do
      before do
        variant.product.variants << [create(:variant, state: :state_discontinued), create(:variant, state: :state_discontinued)]
      end

      context 'when stock is 0 in one variant' do
        it 'product is available' do
          expect(variant.reload.product.available_on).not_to be nil
          expect(variant.reload.active?).to be true
        end
      end

      context 'when stock is 0 in all variants' do
        it 'product is not available' do
          FactoryGirl.create(:stock_movement, stock_item: variant.stock_items[0], quantity: -1 * variant.total_on_hand)

          expect(variant.reload.product.available_on).to be nil
          expect(variant.reload.active?).to be false
        end
      end
    end
  end
end
