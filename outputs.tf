output "hub_public_ip" {
  description = "Hub VM public IP (if created)."
  value       = var.deploy_hub_vm ? module.hub_vm[0].public_ip : null
}

output "hub_private_ip" {
  value = var.deploy_hub_vm ? module.hub_vm[0].private_ip : null
}

output "spoke_a_private_ip" {
  value = var.deploy_spoke_vms ? module.spoke_a_vm[0].private_ip : null
}

output "spoke_b_private_ip" {
  value = var.deploy_spoke_vms ? module.spoke_b_vm[0].private_ip : null
}
