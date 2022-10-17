#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
NC='\033[0m'

function checktools {
  if $(which -s git az docker aws terraform kubectl); then
    echo -e "Tools installed on Mac : git az docker awscli terraform kubectl , great."
  else
    echo -e "${RED}Either one or more tools are missing : git az docker awscli terraform kubectl${NC}"
  fi
} # End checktools

function activationid {
  while true
  do
  read -r -p "Did you update ActivationID, CustomerID and Pod URL in terraform.tfvars? [Y/n] " input
 
      case $input in
            [yY][eE][sS]|[yY])
                  echo "Great"
                  echo -e "==============================================================="
                  echo -e "${ORANGE}Execute below commands."
                  echo -e "1. az login"
		  echo -e "2. terraform init" 
		  echo -e "3. terraform apply" 
		  echo -e "4. Execute after terraform creates environment : ./demo_prep.sh <Public IP>${NC}" 
                  echo -e "==============================================================="
                  break
                  ;;
            [nN][oO]|[nN])
                  echo -e "${RED}Please update and execute this script again.${NC}"
                  break
                  ;;
            *)
                  echo "Invalid input..."
                  ;;
      esac      
done
} # End activationid

function qcaexe {
  while true
  do
  read -r -p "Did you download latest QualysCloudAgent.exe to current working directory? [Y/n] " input

      case $input in
            [yY][eE][sS]|[yY])
                  echo -e "${GREEN}Great${NC}"
                  break
                  ;;
            [nN][oO]|[nN])
                  echo -e "${RED}Please download latest QualysCloudAgent.exe and execute this script again.${NC}"
                  break
                  ;;
            *)
                  echo "Invalid input..."
                  ;;
      esac
done
} # End qcaexe

checktools
qcaexe
activationid
