#!/bin/bash

# Variables
installqca="powershell/qcainstall.ps1"

custid=`grep -e ^customerid terraform.tfvars | cut -d"\"" -f2`
actid=`grep -e ^activationid terraform.tfvars | cut -d"\"" -f2`
podurl=`grep -e ^pod_url terraform.tfvars | cut -d"\"" -f2`


# Create install Powershell with Qualys parametersm Chrome and Firefox
function install_powershell {
	
  echo "Start-Process -Wait -FilePath \"C:\Qualys\QualysCloudAgent.exe\" -ArgumentList \"CustomerId={$custid} ActivationId={$actid} WebServiceUri=$podurl/CloudAgent/\"" > $installqca
  echo "Start-Sleep -Seconds 30" >> $installqca
  echo "New-ItemProperty -Path HKLM:/Software/Qualys/QualysAgent/ScanOnDemand/Vulnerability -Name ScanOnDemand -Value 1 -PropertyType DWORD -Force" >> $installqca

} # End install_powershell

install_powershell 

