variable "rg_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "storage_account_name" { type = string }

variable "vnet_id" { type = string }
variable "vnet_name" { type = string }

variable "private_endpoint_subnet_id" { type = string }
