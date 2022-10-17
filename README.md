# Qualys Patch Management POC and Demo 
Repository for Demo and POC of Qualys Patch Management with Cloud Agent

## Start POC/Demo
git clone https://github.com/niravk1/qualys_pm_poc_demo.git \
cd qualys_pm_poc_demo/azure/win10-stock-image-20h2-ent-g2/ 

- Update terraform.tfvars (Imp : Windows Username, Windows Password, Qualys Activation ID, Customer ID and POD URL)
- Download and copy QualysCloudAgent.exe to folder qualys_pm_poc_demo/azure/win10-stock-image-20h2-ent-g2/

chmod +x *.sh ; ./env_prep.sh \
terraform init \
terraform apply \
./demo_prep.sh 

## Destroy POC/Demo
terraform destroy 
- Script : qca_remove.sh , can deactivate and uninstall Qualys Cloud Agent from QCP. 
