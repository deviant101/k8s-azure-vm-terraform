output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.internal.name
}

output "vm1_public_ip" {
  description = "Public IP address of VM1"
  value       = azurerm_public_ip.vm1.ip_address
}

output "vm2_public_ip" {
  description = "Public IP address of VM2"
  value       = azurerm_public_ip.vm2.ip_address
}

output "vm1_private_ip" {
  description = "Private IP address of VM1"
  value       = azurerm_network_interface.vm1.private_ip_address
}

output "vm2_private_ip" {
  description = "Private IP address of VM2"
  value       = azurerm_network_interface.vm2.private_ip_address
}

output "vm1_ssh_connection" {
  description = "SSH connection command for VM1"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.vm1.ip_address}"
}

output "vm2_ssh_connection" {
  description = "SSH connection command for VM2"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.vm2.ip_address}"
}
