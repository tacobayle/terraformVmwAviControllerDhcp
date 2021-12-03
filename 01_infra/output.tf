# Outputs for Terraform

output "controller_ip_dhcp_cluster" {
  value = var.dhcp == true && var.avi_cluster== true ? vsphere_virtual_machine.controller_dhcp_cluster.*.default_ip_address : null
}

output "controller_ip_dhcp_standalone" {
  value = var.dhcp == true && var.avi_cluster== false ? vsphere_virtual_machine.controller_dhcp_standalone.*.default_ip_address : null
}

output "controller_ip_static_cluster" {
  value = var.dhcp == false && var.avi_cluster== true ? vsphere_virtual_machine.controller_static_cluster.*.default_ip_address : null
}

output "controller_ip_static_standalone" {
  value = var.dhcp == false && var.avi_cluster== false ? vsphere_virtual_machine.controller_static_standalone.*.default_ip_address : null
}