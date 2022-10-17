output "random_integer" {
  value = random_integer.qualys.result
}

output "random_pet" {
  value = random_pet.qualys.id
}

output "random_string" { 
  value = random_string.qualys.id
} 

output "resource_group_name" {
  value = azurerm_resource_group.qualys.name
}

output "azurerm_windows_virtual_machine" {
  value = azurerm_windows_virtual_machine.qualys.name
}

output "static_public_ip" {
  value = azurerm_public_ip.qualys.ip_address
}

output "public_fqdn" {
  value = azurerm_public_ip.qualys.fqdn
}

### Commands to Execute after terraform run
output "z_run_demo_prep" {
  description = "Display the output"
  value       = "Login Details : RDP"
}
output "z_run_demo_prep1" {
  value = "execute demo_prep.sh"
}