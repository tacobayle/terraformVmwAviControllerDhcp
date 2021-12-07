#!/bin/bash
#
# Orchestrate TF apply
#
cd 01_infra
terraform init
terraform apply -auto-approve
cd -

cd 02_avi_username
terraform init
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json
cd -
#
#cd 03_avi_config
#terraform init
#terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json
#cd -
#
#cd 04_avi_cluster
#terraform init
#terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json
#cd -
#