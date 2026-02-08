# 1) Resource groups
module "rg" {
  source = "./modules/rg"

  networking_rg_name = var.resource_groups.networking
  compute_rg_name    = var.resource_groups.compute
  location           = var.location
  tags               = var.tags
}

# 2) Hub VNet + subnets
module "hub_network" {
  source = "./modules/network-hub"

  rg_name       = module.rg.networking_rg_name
  location      = var.location
  vnet_name     = "vnet-hub"
  address_space = local.address_spaces.hub

  workload_subnet_name = local.subnets.hub_workload.name
  workload_subnet_cidr = local.subnets.hub_workload.cidr

  pe_subnet_name = local.subnets.hub_private_endpoints.name
  pe_subnet_cidr = local.subnets.hub_private_endpoints.cidr

  tags = var.tags
}

# 3) Spoke VNets + workload subnets
module "spoke_a_network" {
  source = "./modules/network-spoke"

  rg_name       = module.rg.networking_rg_name
  location      = var.location
  vnet_name     = "vnet-spoke-a"
  address_space = local.address_spaces.spokeA

  workload_subnet_name = local.subnets.spoke_a_workload.name
  workload_subnet_cidr = local.subnets.spoke_a_workload.cidr

  tags = var.tags
}

module "spoke_b_network" {
  source = "./modules/network-spoke"

  rg_name       = module.rg.networking_rg_name
  location      = var.location
  vnet_name     = "vnet-spoke-b"
  address_space = local.address_spaces.spokeB

  workload_subnet_name = local.subnets.spoke_b_workload.name
  workload_subnet_cidr = local.subnets.spoke_b_workload.cidr

  tags = var.tags
}

# 4) Centralized NSG + rules
module "nsg" {
  source = "./modules/nsg"

  rg_name  = module.rg.networking_rg_name
  location = var.location
  nsg_name = "nsg-workload"

  my_public_ip_cidr = var.my_public_ip_cidr

  # NEW: hub subnet lookup inputs (NO CIDR hardcoding)
  hub_subnet_name  = "snet-workload"
  hub_vnet_name    = "vnet-hub"
  hub_vnet_rg_name = module.rg.networking_rg_name

  # Allow spokes to reach hub via RDP (lab convenience)
  spoke_address_spaces = [
    local.address_spaces.spokeA,
    local.address_spaces.spokeB
  ]

  tags = var.tags
}

# 5) Associate NSG to subnets (hub + spokes)
module "nsg_assoc_subnets" {
  source = "./modules/nsg-subnet-assoc"

  nsg_id = module.nsg.nsg_id

  subnet_ids = {
    hub    = module.hub_network.workload_subnet_id
    spokeA = module.spoke_a_network.workload_subnet_id
    spokeB = module.spoke_b_network.workload_subnet_id
  }
}

# 6) Windows VMs (hub + spokes)
module "hub_vm" {
  count  = var.deploy_hub_vm ? 1 : 0
  source = "./modules/vm-linux"

  rg_name   = module.rg.compute_rg_name
  location  = var.location
  vm_name   = "vm-workload-01"
  subnet_id = module.hub_network.workload_subnet_id

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key

  vm_size = var.vm_size

  create_public_ip = var.create_hub_public_ip
  tags             = var.tags
}

module "spoke_a_vm" {
  count  = var.deploy_spoke_vms ? 1 : 0
  source = "./modules/vm-linux"

  rg_name   = module.rg.compute_rg_name
  location  = var.location
  vm_name   = "vm-spoke-a-01"
  subnet_id = module.spoke_a_network.workload_subnet_id

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key

  vm_size = var.vm_size

  create_public_ip = false
  tags             = var.tags
}

module "spoke_b_vm" {
  count  = var.deploy_spoke_vms ? 1 : 0
  source = "./modules/vm-linux"

  rg_name   = module.rg.compute_rg_name
  location  = var.location
  vm_name   = "vm-spoke-b-01"
  subnet_id = module.spoke_b_network.workload_subnet_id

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key

  vm_size = var.vm_size

  create_public_ip = false
  tags             = var.tags
}

# 7) Associate NSG to NICs (hub + spokes) - lab choice
module "nsg_assoc_hub_nic" {
  count   = var.deploy_hub_vm ? 1 : 0
  source  = "./modules/nsg-nic-assoc"
  nsg_id  = module.nsg.nsg_id
  nic_ids = { hub = module.hub_vm[0].nic_id }
}

module "nsg_assoc_spoke_nics" {
  count  = var.deploy_spoke_vms ? 1 : 0
  source = "./modules/nsg-nic-assoc"
  nsg_id = module.nsg.nsg_id
  nic_ids = {
    spokeA = module.spoke_a_vm[0].nic_id
    spokeB = module.spoke_b_vm[0].nic_id
  }
}


# 8) VNet peerings (hub ↔ spokes)
module "peerings" {
  source = "./modules/peering"

  rg_name = module.rg.networking_rg_name

  hub_vnet_name = module.hub_network.vnet_name
  hub_vnet_id   = module.hub_network.vnet_id

  spoke_vnets = {
    spokeA = { name = module.spoke_a_network.vnet_name, id = module.spoke_a_network.vnet_id }
    spokeB = { name = module.spoke_b_network.vnet_name, id = module.spoke_b_network.vnet_id }
  }
}

# 9) Storage + Private Endpoint + Private DNS (Hub)
module "storage_pe" {
  source = "./modules/private-endpoint-storage"

  rg_name  = module.rg.networking_rg_name
  location = var.location
  tags     = var.tags

  storage_account_name = var.storage_account_name

  vnet_id   = module.hub_network.vnet_id
  vnet_name = module.hub_network.vnet_name

  private_endpoint_subnet_id = module.hub_network.private_endpoint_subnet_id
}
