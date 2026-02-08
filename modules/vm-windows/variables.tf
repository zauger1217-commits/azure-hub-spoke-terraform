variable "rg_name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }

variable "vm_name" { type = string }
variable "subnet_id" { type = string }

variable "admin_username" { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1ms"
  description = "VM size (change if capacity restricted in your region)."
}

variable "create_public_ip" {
  type        = bool
  default     = false
  description = "Create a public IP for this VM."
}
