# encoding: utf-8
require 'spec_helper'

RSpec.describe Spree::Variant, type: :model do
  let(:variant) { FactoryGirl.create(:variant, :with_stock) }

  it 'variant has normal state' do
    expect(variant.state_name).to eq I18n.t('activerecord.attributes.spree/product.active')
  end

  context '#discontinued' do
    before do
      variant.update state: :discontinued
    end

    it 'variant is active' do
      expect(variant.active?).to be true
      expect(variant.state_name).to eq I18n.t('activerecord.attributes.spree/product.discontinued')
    end

    context 'with no stock' do
      it 'variant is no_active' do
        variant.stock_items.first.set_count_on_hand 0
        expect(variant.no_active?).to be true
        expect(variant.state_name).to eq I18n.t('activerecord.attributes.spree/product.no_active')
      end
    end
  end

  context '#descontinued' do
    before do
      variant.update state: :descontinued
    end

    it 'variant is active' do
      expect(variant.active?).to be true
      expect(variant.state_name).to eq I18n.t('activerecord.attributes.spree/product.descontinued')
    end

    context 'with no stock' do
      it 'variant is no_active' do
        variant.stock_items.first.set_count_on_hand 0
        expect(variant.no_active?).to be true
        expect(variant.state_name).to eq I18n.t('activerecord.attributes.spree/product.no_active')
      end
    end
  end
end
