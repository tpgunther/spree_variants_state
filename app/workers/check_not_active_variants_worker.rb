class CheckNotActiveVariantsWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(variant_ids)
    Spree::Variant.where(id: variant_ids).each(&:check_no_active_product)
  end
end
