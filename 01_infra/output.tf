# Outputs for Terraform

output "controller_ip_dhcp_cluster" {
  value = vsphere_virtual_machine.controller_dhcp.*.default_ip_address
}