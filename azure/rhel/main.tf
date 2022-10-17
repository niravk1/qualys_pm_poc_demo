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

# Virtual Machine for Registry Sensor Deployment #
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
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
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
resource "azurerm_linux_virtual_machine" "qualys" {
  name                  = "${var.prefix}-vm${random_integer.qualys.result}"
  location              = azurerm_resource_group.qualys.location
  resource_group_name   = azurerm_resource_group.qualys.name
  network_interface_ids = [azurerm_network_interface.qualys.id]
  size                  = "${var.vmsize}"

  os_disk {
    name              = "${var.prefix}-vm-osdisk${random_integer.qualys.result}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

#Oracle:Oracle-Linux:ol85-lvm:8.5.7
#Canonical:UbuntuServer:18.04-LTS:latest
#RedHat:RHEL:8_5:8.5.2022032201
#RedHat:rhel-raw:8_1:8.1.2021011901
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_5"
    version   = "8.5.2022032201"
  }
/*
  source_image_reference {
    publisher = "var.img_publisher"
    offer     = "var.img_offer"
    sku       = "var.img_sku"
    version   = "var.img_version"
  }
*/

    computer_name  = "${var.prefix}-vm${random_integer.qualys.result}"
    admin_username = "${var.vmadminuser}"
    disable_password_authentication = true

    admin_ssh_key {
      username   = "${var.vmadminuser}"
      public_key = tls_private_key.qualys.public_key_openssh
    }
  tags = "${var.tags}"
}

resource "null_resource" "local_provisioners" {
  
  depends_on = [
    azurerm_linux_virtual_machine.qualys , 
    azurerm_resource_group.qualys 
    ]

  provisioner "local-exec" {
      command = "/bin/bash scripts/local_script.sh"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo '----- Destroy-time provisioner -----' " 
  }
}

# Remote Execution of Scripts & Commands

resource "null_resource" "remote-exec" {
  depends_on = [
    azurerm_linux_virtual_machine.qualys , 
    azurerm_resource_group.qualys 
    ]
    provisioner "file" {
    source      = "QualysCloudAgent.rpm"
    destination = "/tmp/QualysCloudAgent.rpm"
    
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.qualys.ip_address
      user        = "${var.vmadminuser}"
      private_key = tls_private_key.qualys.private_key_pem
    }
  }
    provisioner "file" {
    source      = "scripts/remote_script.sh"
    destination = "/tmp/remote_script.sh"
    
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.qualys.ip_address
      user        = "${var.vmadminuser}"
      private_key = tls_private_key.qualys.private_key_pem
    }
  }
  
    provisioner "remote-exec" {
    
    inline = [
      "echo \"export ACTIVATIONID=${var.activationid}\" >> ~/.bashrc" ,
      "echo \"export CUSTOMERID=${var.customerid}\" >> ~/.bashrc" ,
      "echo \"export POD_URL=${var.pod_url}\" >> ~/.bashrc" ,
      "export ACTIVATIONID=${var.activationid}" , 
      "export CUSTOMERID=${var.customerid}" , 
      "export POD_URL=${var.pod_url}" , 
      "echo \"ACTIVATIONID=${var.activationid}\" > /tmp/.qualysenv.env" ,
      "echo \"CUSTOMERID=${var.customerid}\" >> /tmp/.qualysenv.env" ,
      "echo \"POD_URL=${var.pod_url}\" >> /tmp/.qualysenv.env" ,

      "sudo chmod +x /tmp/remote_script.sh" ,
      "sudo /tmp/remote_script.sh" , 
      "rm -f /tmp/.qualysenv.env"

      ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.qualys.ip_address
      user        = "${var.vmadminuser}"
      private_key = tls_private_key.qualys.private_key_pem
    }
  }
}
