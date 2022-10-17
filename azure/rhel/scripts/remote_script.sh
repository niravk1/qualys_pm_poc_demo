#!/bin/bash

echo "Executing Remote Script."

function rhocp_remote_operator {
	sudo dnf install -y git make go wget 
        wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/operator-sdk/4.9.0/operator-sdk-v1.10.1-ocp-linux-x86_64.tar.gz
	tar xvf operator-sdk-v1.10.1-ocp-linux-x86_64.tar.gz
	chmod +x operator-sdk
 	echo $PATH
	sudo mv ./operator-sdk /usr/local/bin/operator-sdk
	operator-sdk version	
    	cd ~
	mkdir nginx-operator ; cd nginx-operator
	operator-sdk init --plugins=helm
	operator-sdk create api --group demo --version v1 --kind Nginx

	cd ~
        mkdir cs-sensor-operator ; cd cs-sensor-operator 
#	operator-sdk init --plugins=helm
	git clone https://github.com/Qualys/cs_sensor.git
	mv cs_sensor/helm-chart-scripts/cssensor-chart-openshift-crio-ds ~/cs-sensor-operator/
	rm -rf cs_sensor
	mv cssensor-chart-openshift-crio-ds/* helm-charts/ ; rm -rf cssensor-chart-openshift-crio-ds
#    operator-sdk init --plugins=helm --domain=example.com --group=demo --version=v1 --kind=qcs-sensor 

} # End rhocp_remote_operator

function rh_qca_install {
	sudo dnf install -y git make go wget 
	sudo rpm -ivh /tmp/QualysCloudAgent.rpm 	
	source /tmp/.qualysenv.env 
	sudo /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=$ACTIVATIONID CustomerId=$CUSTOMERID
	sleep 10
	sudo /usr/local/qualys/cloud-agent/bin/cloudagentctl.sh action=demand type=vmpc
} # End rh_qca_install


function ubunturemote {

	apt update > /dev/null
	apt install -y python3-pip apt-transport-https ca-certificates curl software-properties-common > /dev/null
	# Install docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - > /dev/null
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt update -qq > /dev/null
	apt install -y docker-ce > /dev/null
	#usermod -aG docker ubuntu > /dev/null
	# Install Azure CLI
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash > /dev/null

} # End ubunturemote

# Main 

if (ls /etc/redhat-release >/dev/null ) ; then
  rh_qca_install
else 
  ubunturemote
fi
