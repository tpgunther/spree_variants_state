class AddDisableToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :disable, :boolean, default: false
  end
end
