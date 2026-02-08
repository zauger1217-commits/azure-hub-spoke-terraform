variable "rg_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "nsg_name" { type = string }

variable "my_public_ip_cidr" { type = string }
variable "spoke_address_spaces" {
  type        = list(string)
  description = "Spoke VNet CIDRs allowed to RDP into hub (lab)."
  default     = []
}

variable "hub_subnet_name" {
  type        = string
  description = "Name of the hub subnet that should be allowed to SSH into spokes"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub virtual network"
}

variable "hub_vnet_rg_name" {
  type        = string
  description = "Resource group name where the hub virtual network exists"
}
