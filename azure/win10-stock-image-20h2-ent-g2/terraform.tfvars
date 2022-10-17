### Azure, Naming & Tags Configuration ###
location = "Australia Southeast" # Default location = "West US"
tags = {
  projectname = "Qualys"          # Defaults projectname = "Qualys"
  env         = "Qualys-POC-Demo" # Defaults env = "Qualys-POC-Demo"
  owner       = "Qualys"          # Defaults owner = "Qualys"
  department  = "POC-Demo"        # Defaults department = "POC-Demo"
}
prefix = "tfqpm" # Defaults prefix = "qualys" 

### Virtual Machine Configuration ###
vmsize          = "Standard_D2s_v3" # Default vmsize = "Standard_B2s"
vmadminuser     = "azureuser"       # vmadminuser = "azureuser" 
vmpassword      = "P@$$w0rd1234!"   # vmpassword = "complexpassword"
source_image_id = "/subscriptions/19c33874-2b9c-4a87-973c-5e0dc38f19ac/resourceGroups/Global-SSA-DEMO/providers/Microsoft.Compute/images/ssa-win10-pm-template"

### Qualys Agent 
activationid="activati-0000-0000-0000-000000000000"
customerid="customer-0000-0000-0000-000000000000"
pod_url="https://qagpublic.POD.apps.qualys.com"

### Azure Authentication Configuration ###
#azure_client_id = "your-azure-client-id"
#azure_client_secret = "your-azure-client-secret"
#azure_subscription_id = "your-azure-subscription-id"
#azure_tenant_id = "your-azure-tenant-id"
