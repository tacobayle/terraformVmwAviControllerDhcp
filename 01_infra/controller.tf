resource "vsphere_virtual_machine" "controller_dhcp_cluster" {
  count            = (var.dhcp == true && var.avi_cluster== true ? 3 : 0)
  name             = "controller-${count.index}"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  num_cpus = var.controller.cpu
  memory = var.controller.memory
  wait_for_guest_net_timeout = var.controller.wait_for_guest_net_timeout
  guest_id = "guestid-controller-${count.index}"

  disk {
    size             = var.controller.disk
    label            = "controller--${count.index}.lab_vmdk"
    thin_provisioned = true
  }

  clone {
    template_uuid = vsphere_content_library_item.file.id
  }
}

resource "vsphere_virtual_machine" "controller_dhcp_standalone" {
  count            = (var.dhcp == true && var.avi_cluster== false ? 1 : 0)
  name             = "controller-${count.index}"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  num_cpus = var.controller.cpu
  memory = var.controller.memory
  wait_for_guest_net_timeout = var.controller.wait_for_guest_net_timeout
  guest_id = "guestid-controller-${count.index}"

  disk {
    size             = var.controller.disk
    label            = "controller--${count.index}.lab_vmdk"
    thin_provisioned = true
  }

  clone {
    template_uuid = vsphere_content_library_item.file.id
  }
}

resource "null_resource" "wait_https_controller_dhcp_cluster" {
  depends_on = [vsphere_virtual_machine.controller_dhcp_cluster]
  count            = (var.dhcp == true && var.avi_cluster== true ? 3 : 0)

  provisioner "local-exec" {
    command = "until $(curl --output /dev/null --silent --head -k https://${vsphere_virtual_machine.controller_dhcp_cluster[count.index].default_ip_address}); do echo 'Waiting for Avi Controllers to be ready'; sleep 10 ; done"
  }
}

resource "null_resource" "wait_https_controller_dhcp_standalone" {
  depends_on = [vsphere_virtual_machine.controller_dhcp_standalone]
  count            = (var.dhcp == true && var.avi_cluster== false ? 3 : 0)

  provisioner "local-exec" {
    command = "until $(curl --output /dev/null --silent --head -k https://${vsphere_virtual_machine.controller_dhcp_cluster[count.index].default_ip_address}); do echo 'Waiting for Avi Controllers to be ready'; sleep 10 ; done"
  }
}

resource "local_file" "output_json_file_02_dhcp_cluster" {
  count            = (var.dhcp == true && var.avi_cluster== true ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_cluster.*.default_ip_address)}, \"avi_version\": ${jsonencode(var.avi_version)}, \"avi_tenant\": ${jsonencode(var.avi_tenant)}, \"avi_current_password\": ${jsonencode(var.avi_current_password)}}"
  filename = "../02_avi_username/inputs.json"
}

resource "local_file" "output_json_file_03_dhcp_cluster" {
  count            = (var.dhcp == true && var.avi_cluster== true ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_cluster.*.default_ip_address)}, \"avi_version\": ${jsonencode(var.avi_version)}, \"avi_tenant\": ${jsonencode(var.avi_tenant)}, \"avi_cluster\": ${jsonencode(var.avi_cluster)}, \"deployment_id\": ${jsonencode(random_string.id.result)}}"
  filename = "../03_avi_config/inputs.json"
}

resource "local_file" "output_json_file_02_dhcp_standalone" {
  count            = (var.dhcp == true && var.avi_cluster== false ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_standalone.*.default_ip_address)}, \"avi_version\": ${jsonencode(var.avi_version)}, \"avi_tenant\": ${jsonencode(var.avi_tenant)}, \"avi_current_password\": ${jsonencode(var.avi_current_password)}}"
  filename = "../02_avi_username/inputs.json"
}

resource "local_file" "output_json_file_03_dhcp_standalone" {
  count            = (var.dhcp == true && var.avi_cluster== false ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_standalone.*.default_ip_address)}, \"avi_version\": ${jsonencode(var.avi_version)}, \"avi_tenant\": ${jsonencode(var.avi_tenant)}, \"avi_cluster\": ${jsonencode(var.avi_cluster)}, \"deployment_id\": ${jsonencode(random_string.id.result)}}"
  filename = "../03_avi_config/inputs.json"
}