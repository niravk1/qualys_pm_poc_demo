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

output "azurerm_linux_virtual_machine" {
  value = azurerm_linux_virtual_machine.qualys.name
}

output "tls_private_key" { 
    value = tls_private_key.qualys.private_key_pem 
    sensitive = true
}

output "static_public_ip" {
  value = azurerm_public_ip.qualys.ip_address
}

### Commands to Execute after terraform run
output "z_run_demo_prep" {
  description = "Display the output"
  value       = "RUN THE SCRIPT DEMO_PREP : ./demo_Prep.sh"
}
output "z_run_demo_prep1" {
  value = "sudo /usr/local/qualys/cloud-agent/bin/cloudagentctl.sh action=demand type=vmpc"
}
