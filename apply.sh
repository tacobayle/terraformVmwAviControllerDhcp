#!/bin/bash
#
# Orchestrate TF apply
#
cd 01_infra
terraform init
terraform apply -auto-approve
cd -
#
cd 02_avi_username
terraform init
terraform apply -auto-approve -var-file=controllers.json -var-file=avi_config.json
cd -
#