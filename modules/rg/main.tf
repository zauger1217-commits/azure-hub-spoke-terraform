resource "azurerm_resource_group" "networking" {
  name     = var.networking_rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "compute" {
  name     = var.compute_rg_name
  location = var.location
  tags     = var.tags
}
