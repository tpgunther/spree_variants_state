class AddStateToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :state, :integer
  end
end
