resource "random_pet" "qualys" {}
# Create Random Integer
resource "random_integer" "qualys" {
  min = 1
  max = 99
}
# Create Random String
resource "random_string" "qualys" {
  length  = 8
  special = false
}
# Create Resource Group
resource "azurerm_resource_group" "qualys" {
  name     = "${var.prefix}-rg${random_integer.qualys.result}"
  location = "${var.location}"
  tags     = "${var.tags}"
}
# Virtual Machine
# Create virtual network
resource "azurerm_virtual_network" "qualys" {
  name                = "${var.prefix}-vnet${random_integer.qualys.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.qualys.location
  resource_group_name = azurerm_resource_group.qualys.name
}
# Create subnet
resource "azurerm_subnet" "qualys" {
  name                 = "${var.prefix}-subnet${random_integer.qualys.result}"
  resource_group_name  = azurerm_resource_group.qualys.name
  virtual_network_name = azurerm_virtual_network.qualys.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create network interface
resource "azurerm_network_interface" "qualys" {
  name                = "${var.prefix}-nic${random_integer.qualys.result}"
  location            = azurerm_resource_group.qualys.location
  resource_group_name = azurerm_resource_group.qualys.name

  ip_configuration {
    name                          = "${var.prefix}nicconfig"
    subnet_id                     = azurerm_subnet.qualys.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.qualys.id
  }
}
# Create public IPs
resource "azurerm_public_ip" "qualys" {
  name                = "${var.prefix}-publicip${random_integer.qualys.result}"
  location            = azurerm_resource_group.qualys.location
  resource_group_name = azurerm_resource_group.qualys.name
  allocation_method   = "Static"
}
# Create Network Security Group and rule
resource "azurerm_network_security_group" "qualys" {
  name                = "${var.prefix}-nsg${random_integer.qualys.result}"
  location            = azurerm_resource_group.qualys.location
  resource_group_name = azurerm_resource_group.qualys.name
  security_rule {
    name                       = "allow-rdp"
    description                = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }
  security_rule {
    name                       = "allow-winrm-http"
    description                = "allow-winrm-http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }
  security_rule {
    name                       = "AllowAnySSHInbound"
    description                = "AllowAnySSHInbound"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }
  tags     = "${var.tags}" 
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "qualysassociate" {
  network_interface_id      = azurerm_network_interface.qualys.id
  network_security_group_id = azurerm_network_security_group.qualys.id
}
# Create keys
resource "tls_private_key" "qualys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create VM 
resource "azurerm_windows_virtual_machine" "qualys" {
  name                  = "${var.prefix}-vm${random_integer.qualys.result}"
  location              = azurerm_resource_group.qualys.location
  resource_group_name   = azurerm_resource_group.qualys.name
  size                  = "${var.vmsize}"
  admin_username        = "${var.vmadminuser}"
  admin_password        = "${var.vmpassword}"

  network_interface_ids = [azurerm_network_interface.qualys.id]

  os_disk {
    name              = "${var.prefix}-vm-osdisk${random_integer.qualys.result}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.img_publisher
    offer     = var.img_offer
    sku       = var.img_sku
    version   = var.img_version
  }
  computer_name  = "${var.prefix}-vm${random_integer.qualys.result}"
  tags = "${var.tags}"
}

# Virtual Machine Extension 
resource "azurerm_virtual_machine_extension" "win-vm-extension" {
  depends_on=[azurerm_windows_virtual_machine.qualys]

  name = "win-${var.prefix}-vm-extension-${random_integer.qualys.result}"
  virtual_machine_id   = azurerm_windows_virtual_machine.qualys.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    { 
      "fileUris": ["https://raw.githubusercontent.com/niravk1/qcsdemo/master/winrmssh.ps1"]
    } 
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File winrmssh.ps1"
      }
  PROTECTED_SETTINGS
  tags = "${var.tags}"
}

# Remote Execution of Scripts & Commands
resource "null_resource" "remote-exec" {
  depends_on = [
    azurerm_windows_virtual_machine.qualys ,
    azurerm_resource_group.qualys, 
    azurerm_virtual_machine_extension.win-vm-extension
    ]
connection {
      type     = "winrm"
      timeout  = "2m"
      insecure = true
      user     = "${var.vmadminuser}"
      password = "${var.vmpassword}"
      host     = azurerm_public_ip.qualys.ip_address
    }

# Copies the file or folder as the Administrator user using WinRM
  provisioner "file" {
    source      = "powershell"
    destination = "C:/Qualys"
  }
  provisioner "remote-exec" {
    inline = [
      "powershell -ExecutionPolicy Unrestricted -File C:/Qualys/swinstall.ps1"
    ]
  }
}

resource "null_resource" "local_provisioners" {
  
  depends_on = [
    azurerm_windows_virtual_machine.qualys , 
    azurerm_resource_group.qualys 
    ]
  provisioner "local-exec" {
    command = "sh qca_init.sh"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo '----- Destroy-time provisioner -----' " 
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f powershell/qcainstall.ps1" 
  }
}
