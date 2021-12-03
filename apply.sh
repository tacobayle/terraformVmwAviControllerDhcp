#!/bin/bash
#
# Orchestrate TF apply
#
cd 01_infra
terraform init
terrafom apply -auto-approve
cd -
#
cd 02_avi_username
terraform init
terrafom apply -auto-approve -var-file==inputs.json
cd -
#