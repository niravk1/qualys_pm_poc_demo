### Azure, Naming & Tags Configuration ###
location = "Australia Southeast"        # Default location = "West US"
tags = {
projectname = "Qualys-Container-Sensor-QCS"  # Defaults projectname = "Qualys-Container-Sensor-QCS"
env = "Qualys-POC-Demo"                         # Defaults env = "Qualys-POC-Demo"
owner = "Qualys"  		          # Defaults owner = "Qualys"
department = "POC-Demo"                      # Defaults department = "POC-Demo"
}
prefix = "tfqpm"                        # Defaults prefix = "qualys" 

### Virtual Machine Configuration ###
vmsize = "Standard_B2s"                 # Default vmsize = "Standard_B2s"
vmadminuser = "azureuser"               # vmadminuser = "azureuser" 
vmpassword = "complexpassword"


### Image ###
#Oracle:Oracle-Linux:ol85-lvm:8.5.7
#Canonical:UbuntuServer:18.04-LTS:latest
#RedHat:RHEL:8_5:8.5.2022032201
#MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest
#MicrosoftWindowsServer:WindowsServer:2022-Datacenter:latest
#MicrosoftWindowsDesktop:windows-ent-cpc:win10-21h2-ent-cpc-m365:19044.1826.220712
#RedHat:rhel-raw:8_1:8.1.2021011901

img_publisher = "RedHat"
img_offer = "rhel"
img_sku = "8_1"
img_version = "8.1.2021011901"

### Qualys Container Sensor 
activationid="activati-0000-0000-0000-000000000000"
customerid="customer-0000-0000-0000-000000000000"
pod_url="https://qagpublic.POD.apps.qualys.com"

### Azure Authentication Configuration ###
#azure_client_id = "your-azure-client-id"
#azure_client_secret = "your-azure-client-secret"
#azure_subscription_id = "your-azure-subscription-id"
#azure_tenant_id = "your-azure-tenant-id"