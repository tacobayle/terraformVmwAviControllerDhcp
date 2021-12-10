# tfVmwAviController

## Goal
Terraform | Deploy Avi Controller Cluster and configure it.

## Prerequisites:
- TF installed in the orchestrator VM
- jq installed in the orchestrator VM
- environment variables:
```
export TF_VAR_vsphere_username=******
export TF_VAR_vsphere_password=******
export TF_VAR_avi_controller_url=****** # defined the url where Avi controller OVA image will be downloaded
```

## Environment:

Terraform Plan has/have been tested against:

### terraform

https://learn.hashicorp.com/tutorials/terraform/install-cli

```shell
Terraform v1.0.6
on linux_amd64
+ provider registry.terraform.io/hashicorp/null v3.1.0
+ provider registry.terraform.io/hashicorp/template v2.2.0
+ provider registry.terraform.io/hashicorp/vsphere v2.0.2
```

### Avi Version

```
controller-21.1.2-9124.ova
```

## Input/Parameters:
1. All the variables are stored in 01/infra/variables.tf

## Use the terraform plan to:
- Spin up n Avi Controller vCenter environment:
  - if var.cluster is true, 3 VM controller will be deployed
    
- Wait for the https to be ready
- Bootstrap the Avi controller via Ansible  
- Make the Avi controller cluster config via Ansible - floating IP will be configured if var.controller.floating_ip has been defined
- Configure Avi Passphrase via Ansible
- Configure System config via Ansible

## Run TF Plan:
- Git clone the TF plan

```shell
cd ~ ; git clone https://github.com/tacobayle/vmwAviController ; cd vmwAviController ; terraform init ;
```

- Change the variables.tf according to your environment
  
- Build the plan

```shell
terraform apply -auto-approve
```

- Destroy the plan

```shell
terraform destroy -auto-approve
```