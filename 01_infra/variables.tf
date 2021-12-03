#
# Environment Variables
#
variable "vsphere_username" {}
variable "vsphere_password" {}
variable "avi_controller_url" {}


//variable "avi_password" {}
//variable "avi_backup_passphrase" {}
#
# Other Variables
#
variable "vsphere_server" {
  default = "wdc-06-vc12.oc.vmware.com"
}

variable "vcenter_dc" {
  default = "wdc-06-vc12"
}

variable "vcenter_cluster" {
  default = "wdc-06-vc12c01"
}

variable "vcenter_datastore" {
  default = "wdc-06-vc12c01-vsan"
}

variable "vcenter_network" {
  default = "vxw-dvs-34-virtualwire-3-sid-6120002-wdc-06-vc12-avi-mgmt"
}

variable "content_library" {
  default = {
    basename = "content_library_tf_"
  }
}

variable "dhcp" {
  default = true
}

variable "avi_ip4_addresses" {
  default = "10.206.112.55, 10.206.112.56, 10.206.112.57"
}

variable "network_mask" {
  default = "255.255.252.0"
}

variable "gateway4" {
  default = "10.206.112.1"
}

variable "avi_version" {
  default = "21.1.2"
}

variable "avi_cluster" {
  default = true
}

variable "avi_dns_servers" {
    default = "10.206.8.130, 10.206.8.130, 10.206.8.131"
}

variable "avi_ntp_servers" {
  default = "10.206.8.130, 10.206.8.130, 10.206.8.131"
}

variable "avi_password" {
  default = null
}

variable "avi_current_password" {
  default = "58NFaGDJm(PJH0G"
}

variable "avi_tenant" {
  default = "admin"
}

variable "controller" {
  default = {
    cpu = 8
    memory = 24768
    disk = 128
    wait_for_guest_net_timeout = 4
    from_email = "avicontroller@avidemo.fr"
    se_in_provider_context = "true"
    tenant_access_to_provider_se = "true"
    tenant_vrf = "false"
  }
}