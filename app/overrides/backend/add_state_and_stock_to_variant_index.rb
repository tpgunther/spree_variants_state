Deface::Override.new(:virtual_path => 'spree/admin/variants/index',
  :name => 'add_state_and_stock_to_variant_index_1',
  :insert_before => "thead[data-hook='variants_header'] th.actions",
  :text => "
      <th>Stock</th>
      <th>Estado</th>
      <th>Deshabilitado</th>
  ")

Deface::Override.new(:virtual_path => 'spree/admin/variants/index',
  :name => 'add_state_and_stock_to_variant_index_2',
  :insert_before => "tbody td.actions",
  :text => "
      <td class='align-center'><%= variant.total_on_hand %></td>
      <td class='align-center'><%= variant.state_name %></td>
      <td class='align-center'><%= variant.disable %></td>
  ")

