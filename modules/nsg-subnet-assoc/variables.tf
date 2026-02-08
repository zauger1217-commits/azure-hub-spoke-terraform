variable "nsg_id" {
  type        = string
  description = "NSG ID to associate to subnets"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Subnet IDs keyed by name (hub/spokeA/spokeB)"
}
