variable "rg_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "vnet_name" { type = string }
variable "address_space" { type = string }

variable "workload_subnet_name" { type = string }
variable "workload_subnet_cidr" { type = string }

variable "pe_subnet_name" { type = string }
variable "pe_subnet_cidr" { type = string }
