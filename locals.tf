locals {
  address_spaces = {
    hub    = "10.10.0.0/16"
    spokeA = "10.20.0.0/16"
    spokeB = "10.30.0.0/16"
  }

  subnets = {
    hub_workload          = { name = "snet-workload", cidr = "10.10.1.0/24" }
    hub_private_endpoints = { name = "snet-private-endpoints", cidr = "10.10.2.0/24" }
    spoke_a_workload      = { name = "snet-spoke-a", cidr = "10.20.1.0/24" }
    spoke_b_workload      = { name = "snet-spoke-b", cidr = "10.30.1.0/24" }
  }
}
