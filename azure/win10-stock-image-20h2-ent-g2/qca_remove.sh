#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
run_date=`date +"%a %b %e %T %Y"`
time_now=`date +"%Y%m%d_%H%M%S"`

# Specific CIs
qualys_api_url_default="https://qualysapi.qg3.apps.qualys.com"
qualys_api_username_default="quays3nk16"

assetname=$1

if [ -z "$assetname" ]; then
	echo -n -e "Usage : ${RED}./qca_remove.sh <Agent Host Name>${NC} \nExample : ./qca_remove.sh tfqpm-vm44\n" 
    exit
fi

function qualysapiurl {
    
    if [ -n "$qualys_api_url_default" ]; then
                default=" [$qualys_api_url_default]"
    else
                default=
    fi
 # prompt for Qualys API URL
	while true; do
	echo -n -e "QUALYS API URL ${CYAN}$default${NC}: " && read qualys_api_url
	    if [ -n "$qualys_api_url" ]; then
            break
        else 
            if [ -n "$qualys_api_url_default" ]; then
             qualys_api_url=$qualys_api_url_default && break
            fi
        fi
    done
} # End qualysapiurl

function qualysapiusername {

    if [ -n "$qualys_api_username_default" ]; then
        default=" [$qualys_api_username_default]"
    else
        default=
    fi
 # prompt for Qualys API Username
	while true; do
	echo -n -e "QUALYS API Username ${CYAN}$default${NC}: " && read qualys_api_username
	    if [ -n "$qualys_api_username" ]; then
            break
        else
            if [ -n "$qualys_api_username_default" ]; then
            qualys_api_username=$qualys_api_username_default && break
            fi
        fi
    done

} # End qualysapiusername

function qualysapipassword {
read -s -p "QUALYS API Password : " qyalys_api_password
} # End qualysapipassword


function qca_deactivate_uninstall {

    echo -n -e "\nSearching for Cloud Agent Asset ID..."

    assetid=`curl -s -u "$qualys_api_username:$qyalys_api_password" -X "POST" -H "Content-Type: text/xml" -H "Cache-Control: no-cache" --data-binary @requests/list_all_agents.xml "$qualys_api_url/qps/rest/2.0/search/am/hostasset/" | grep  -B 1 $assetname | grep id | cut -d">" -f2 | cut -d"<" -f1`
    echo -n -e "\nCloud Agent Asset ID : $assetid\n"

    if [ -n $assetid ]; then
        echo -n -e "\nDeactivating Cloud Agent $assetname with $assetid...\n"
        curl -u "$qualys_api_username:$qyalys_api_password" -X "POST" -H "Content-Type: text/xml" --data-binary @requests/single_deactivation.xml "$qualys_api_url/qps/rest/2.0/deactivate/am/asset/$assetid?module=AGENT_VM,AGENT_PC,AGENT_FIM,AGENT_EDR,AGENT_SCA"

        sleep 2 
        echo -n -e "\nUninstalling Cloud Agent $assetname with $assetid...\n"
        curl -u "$qualys_api_username:$qyalys_api_password" -X "POST" -H "Content-Type: text/xml" --data-binary @requests/single_uninstall.xml "$qualys_api_url/qps/rest/2.0/uninstall/am/asset/$assetid"

        echo -n -e "\n\nCloud Agent $assetname with $assetid is removed from the platform.\n"
    fi
} # End qca_deactivate_uninstall



# Main 

qualysapiurl
qualysapiusername
qualysapipassword
qca_deactivate_uninstall