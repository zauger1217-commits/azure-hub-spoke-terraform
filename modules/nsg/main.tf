resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}

# --- NEW: dynamically look up the hub subnet CIDR (no hardcoding) ---
data "azurerm_subnet" "hub_subnet" {
  name                 = var.hub_subnet_name
  virtual_network_name = var.hub_vnet_name
  resource_group_name  = var.hub_vnet_rg_name
}

resource "azurerm_network_security_rule" "allow_ssh_MyIP" {
  name                        = "allow_ssh_MyIP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.my_public_ip_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_rdp_from_spokes" {
  for_each = toset(var.spoke_address_spaces)

  name                        = "Allow-RDP-From-${replace(each.value, "/", "-")}"
  priority                    = 110 + index(var.spoke_address_spaces, each.value)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = each.value
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  for_each = toset(var.spoke_address_spaces)

  name                        = "Allow-SSH-From-${replace(each.value, "/", "-")}"
  priority                    = 1000 + index(var.spoke_address_spaces, each.value)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = each.value
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}

# --- NEW: allow SSH from hub subnet to the spokes ---
resource "azurerm_network_security_rule" "allow_ssh_from_hub_subnet" {
  name                        = "Allow-SSH-From-Hub-Subnet"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = data.azurerm_subnet.hub_subnet.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.this.name
}
