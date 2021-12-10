#!/bin/bash
#
# Orchestrate TF
#
tf_init_check () {
  if [ -s init.stderr ] ; then
    echo "TF Init ERRORS:"
    cat init.stderr
    exit 255
  fi
}
#
tf_apply_check () {
  if [ -s apply.stderr ] ; then
    echo "TF Apply ERRORS:"
    cat apply.stderr
    exit 255
  fi
}
#
cd 01_infra
terraform init 2> init.stderr
tf_init_check
terraform apply -auto-approve 2> apply.stderr
tf_apply_check
cd -
#
cd 02_avi_username
if [ -z "$TF_VAR_avi_version" ]; then
  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
else
  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
fi
terraform init 2> init.stderr
tf_init_check
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -compact-warnings 2> apply.stderr
tf_apply_check
cd -
#
cd 03_avi_config
if [ -z "$TF_VAR_avi_version" ]; then
  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
else
  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
fi
terraform init > init.stdout 2> init.stderr
tf_init_check
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json -compact-warnings 2> apply.stderr
tf_apply_check
cd -
#
cd 04_avi_cluster
if [ -z "$TF_VAR_avi_version" ]; then
  sed -i -e 's/version_to_be_replaced/"21.1.2"/g' provider.tf
else
  sed -i -e "s/version_to_be_replaced/\"$TF_VAR_avi_version\"/g" provider.tf
fi
terraform init 2> init.stderr
tf_init_check
terraform apply -auto-approve -var-file=../controllers.json -var-file=../avi_config.json -var-file=../.password.json 2> apply.stderr
tf_apply_check
cd -
#