# Outputs for Terraform

output "controller_ip_dhcp_cluster" {
  value = var.dhcp == true && var.avi_cluster== true ? vsphere_virtual_machine.controller_dhcp_cluster.*.default_ip_address : null
}