#!/bin/bash
#
# Orchestrate TF apply
#
cd 01_infra
terraform init > init.stdout 2> init.stderr
if [ -s init.stderr ] ; then
    echo "TF Init ERRORS:"
    cat init.stderr
    exit 255
fi
terraform apply -auto-approve > apply.stdout 2> apply.stderr
if [ -s apply.stderr ] ; then
    echo "TF Apply ERRORS:"
    cat apply.stderr
    exit 255
fi
cd -
#
cd 02_avi_username
if [ -z "$TF_VAR_avi_version" ]; then
  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
else
  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
fi
terraform init > init.stdout 2> init.stderr
if [ -s init.stderr ] ; then
    echo "TF Init ERRORS:"
    cat init.stderr
    exit 255
fi
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -compact-warnings > apply.stdout 2> apply.stderr
if [ -s apply.stderr ] ; then
    echo "TF Apply ERRORS:"
    cat apply.stderr
    exit 255
fi
cd -
#
cd 03_avi_config
if [ -z "$TF_VAR_avi_version" ]; then
  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
else
  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
fi
terraform init > init.stdout 2> init.stderr
if [ -s init.stderr ] ; then
    echo "TF Init ERRORS:"
    cat init.stderr
    exit 255
fi
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json -compact-warnings > apply.stdout 2> apply.stderr
if [ -s apply.stderr ] ; then
    echo "TF Apply ERRORS:"
    cat apply.stderr
    exit 255
fi
cd -
#
#cd 04_avi_cluster
#if [ -z "$TF_VAR_avi_version" ]; then
#  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
#else
#  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
#fi
#terraform init > init.stdout 2> init.stderr
#if [ -s init.stderr ] ; then
#    echo "TF Init ERRORS:"
#    cat init.stderr
#    exit 255
#fi
#terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json > apply.stdout 2> apply.stderr
#if [ -s apply.stderr ] ; then
#    echo "TF Apply ERRORS:"
#    cat apply.stderr
#    exit 255
#fi
#cd -
#