### Azure, Naming & Tags Configuration ###

variable "location" {
  type = string
  default = "West US"
  description = "Cloud location"
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    projectname = "Qualys"
    env = "Qualys-POC-Demo"
    owner = "Qualys"
    department = "POC-Demo"
  }
}

# Project name prefix 
variable "prefix" {
  type = string
  default = "qcs"
  description = "All resources would have this prefix for identification"
}

### Virtual Machine Configuration ###
variable "vmsize" {
  type = string
  default = "Standard_B2s"
  description = "Virtual Machine Size"
}

variable "vmadminuser" {
  type = string
  default = "azureuser"
  description = "VM Admin Username"
}

variable "vmpassword" {
  type = string
  description = "VM Password"
}

#Oracle:Oracle-Linux:ol85-lvm:8.5.7
#Canonical:UbuntuServer:18.04-LTS:latest
#RedHat:RHEL:8_5:8.5.2022032201
#MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest
#MicrosoftWindowsServer:WindowsServer:2022-Datacenter:latest
#MicrosoftWindowsDesktop:windows-ent-cpc:win10-21h2-ent-cpc-m365:19044.1826.220712

variable "img_publisher" {
  type = string
  description = "VM Image publisher"
  default = "Canonical"
} 
variable "img_offer" {
  type = string
  description = "VM Image offer" 
  default = "UbuntuServer" 
}
variable "img_sku" {
  type = string 
  description = "VM Image SKU"
  default = "18.04-LTS" 
} 
variable "img_version" {
  type = string 
  description = "VM Image Version"
  default = "latest"
} 

### Qualys Sensor 
variable "activationid" {
  type	      = string
  description = "Qualys specific activation id"
}

variable "customerid" {
  type	      = string
  description = "Qualys specific customer id" 
}

variable "pod_url" {
  type	      = string
  description = "Qualys specific pod url" 
}


### Azure Authentication Configuration ###
#Azure authentication variables
#variable "azure_subscription_id" {
#  type = string
#  description = "Azure Subscription ID"
#}
#variable "azure_client_id" {
#  type = string
#  description = "Azure Client ID"
#}
#variable "azure_client_secret" {
#  type = string
#  description = "Azure Client Secret"
#}
#variable "azure_tenant_id" {
#  type = string
#  description = "Azure Tenant ID"
#}
