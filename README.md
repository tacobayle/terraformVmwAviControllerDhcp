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
export TF_VAR_avi_controller_url=****** # defines the url where Avi controller OVA image will be downloaded
```

## Environment:

Terraform Plan has/have been tested against:

### Terraform

- how to install
```
https://learn.hashicorp.com/tutorials/terraform/install-cli
```

- version
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

## Use this repo to:
- configure var.avi_version (default is 21.1.2)
- Spin up n Avi Controller vCenter environment:
  - if var.dhcp is true, VM(s) will obtain IPs through DHCP
  - if var.dhcp is false, VM(s) will obtain IP configuration through:
    - IP(s) via var.avi_ip4_addresses ("10.206.112.55, 10.206.112.56, 10.206.112.57")
    - Netmask via var.network_mask ("255.255.252.0")
    - Gateway via var.gateway4 ("10.206.112.1") 
  - if var.cluster is false, 1 VM controller will be deployed
  - if var.cluster is true, 3 VM controller will be deployed and configured as a cluster
- Configure Avi System config:
  - if var.avi_password is defined it will be used to configure Avi password and Avi passphrase
  - if var.avi_password is not defined a random password will be generated and used to configure Avi password and Avi passphrase, it will be displayed at the end
  - DNS servers via var.avi_dns_server_ips ("8.8.8.8, 10.206.8.130, 10.206.8.131")
  - NTP servers via var.avi_ntp_server_ips ("10.206.8.130, 10.206.8.131, 10.206.8.132")
- Configure Avi cluster:
  - if var.cluster is true, the Avi cluster will be configured
  - a sanity check will make sure the cluster has been configured properly  

## Run TF Plan:
- Git clone

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