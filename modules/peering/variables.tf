variable "rg_name" { type = string }
variable "hub_vnet_name" { type = string }
variable "hub_vnet_id" { type = string }
variable "spoke_vnets" {
  type = map(object({
    name = string
    id   = string
  }))
}
