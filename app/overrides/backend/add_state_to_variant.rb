Deface::Override.new(:virtual_path => 'spree/admin/variants/_form',
  :name => 'add_state_to_variant',
  :insert_bottom => "div[data-hook='admin_variant_form_additional_fields']",
  :text => "
    <div class='field' data-hook='admin_variants_form_state'>
      <%= f.label :state, raw(Spree.t(:state)) %>
      <%= f.select(:state, options_for_select([['Activo','state_active'], ['Descontinuo', 'state_descontinued'], ['Discontinuo', 'state_discontinued']], @variant.state), {}, class: 'select2 fullwidth select2-offscreen') %>
    </div>
  ")

Deface::Override.new(:virtual_path => 'spree/admin/variants/_form',
  :name => 'add_disable_to_variant',
  :insert_bottom => "div[data-hook='admin_variant_form_additional_fields']",
  :text => "
    <div class='field' data-hook='admin_variants_form_disable'>
      <%= f.label :disable, raw(Spree.t(:disable)) %>
      <%= f.select(:disable, options_for_select([['Si', true], ['No', false]], @variant.disable), {}, class: 'select2 fullwidth select2-offscreen') %>
    </div>
  ")
