variable "location" {
  type        = string
  description = "Azure region (e.g., eastus, eastus2)."
}

variable "resource_groups" {
  type = object({
    networking = string
    compute    = string
  })
  description = "Resource group names."
  default = {
    networking = "networking-rg"
    compute    = "compute-rg"
  }
}

variable "admin_username" {
  type        = string
  description = "Windows VM admin username."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "Windows VM admin password (sensitive)."
  sensitive   = true
}

variable "my_public_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32 (used to allow RDP to hub)."
}

variable "create_hub_public_ip" {
  type        = bool
  description = "Whether to create a public IP for the hub VM (recommended for initial access)."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Optional tags."
  default     = { Environment = "Lab", Project = "hub-spoke-terraform" }
}

variable "storage_account_name" {
  type        = string
  description = "Globally-unique storage account name (lowercase letters/numbers only, 3-24 chars)."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID to deploy into."
}

variable "vm_size" {
  type        = string
  description = "VM size for all Windows VMs."
  default     = "Standard_D2s_v3"
}

variable "deploy_hub_vm" {
  type        = bool
  description = "Deploy the hub VM."
  default     = false
}

variable "deploy_spoke_vms" {
  type        = bool
  description = "Deploy the spoke VMs."
  default     = false
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for Linux VMs"
}
