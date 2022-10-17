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

variable "source_image_id" {
  type = string
  description = "Image ID or generalised template id which you want to create VM from" 
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
