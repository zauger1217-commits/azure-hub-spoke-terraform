resource "azurerm_network_interface_security_group_association" "assoc" {
  for_each = var.nic_ids

  network_interface_id      = each.value
  network_security_group_id = var.nsg_id
}
