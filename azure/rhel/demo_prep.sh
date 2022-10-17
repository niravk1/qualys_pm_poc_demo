#!/bin/bash

arg=`terraform output -raw resource_group_name`
pubip=`terraform output static_public_ip`

function vmlogin {
  chmod 640 id_rsa ; rm -f id_rsa
  terraform output -raw tls_private_key > id_rsa
  chmod  400 id_rsa
  echo "Login to VM using below command."
  echo "ssh -i id_rsa azureuser@${pubip}"
} # End vmlogin 

vmlogin
