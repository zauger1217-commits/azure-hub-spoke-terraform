variable "rg_name" { type = string }
variable "location" { type = string }
variable "vm_name" { type = string }
variable "subnet_id" { type = string }

variable "admin_username" { type = string }

# Use SSH (recommended). You can also use password if you want—see below.
variable "ssh_public_key" {
  type        = string
  description = "SSH public key (e.g. contents of ~/.ssh/id_rsa.pub)"
}

variable "vm_size" { type = string }

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
