#!/bin/bash

pubip=$1


if [ -z "$pubip" ]; then
	echo "Usage : ./demo_prep.sh `terraform output static_public_ip` || Have azureuser password handy." 
else
        echo "Copying QualysCloudAgent.exe to Windows VM" 
        if [ -f powershell/qcainstall.ps1 ]; then 
		sh qca_init.sh 
	fi
	scp QualysCloudAgent.exe -o StrictHostKeyChecking=accept-new azureuser@${pubip}
	scp QualysCloudAgent.exe azureuser@${pubip}:C:/Qualys/QualysCloudAgent.exe
        scp powershell/qcainstall.ps1 azureuser@${pubip}:C:/Qualys/qcainstall.ps1
        echo "Executing QualysCloudAgent.exe on Windows VM" 
	ssh azureuser@${pubip} powershell -Command "C:/Qualys/qcainstall.ps1"
fi
