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

resource "vsphere_virtual_machine" "controller_static_cluster" {
  count            = (var.dhcp == false && var.avi_cluster== true ? 3 : 0)
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

  vapp {
    properties = {
      "mgmt-ip"     = split(", ", var.avi_ip4_addresses)[count.index + 0]
      "mgmt-mask"   = var.network_mask
      "default-gw"  = var.gateway4
    }
  }
}

resource "vsphere_virtual_machine" "controller_static_standalone" {
  count            = (var.dhcp == false && var.avi_cluster== false ? 1 : 0)
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

  vapp {
    properties = {
      "mgmt-ip"     = var.avi_ip4_addresses
      "mgmt-mask"   = var.network_mask
      "default-gw"  = var.gateway4
    }
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

resource "null_resource" "wait_https_controller_static_cluster" {
  depends_on = [vsphere_virtual_machine.controller_dhcp_cluster]
  count            = (var.dhcp == false && var.avi_cluster== true ? 1 : 0)

  provisioner "local-exec" {
    command = "until $(curl --output /dev/null --silent --head -k https://${vsphere_virtual_machine.controller_static_cluster[count.index].default_ip_address}); do echo 'Waiting for Avi Controllers to be ready'; sleep 10 ; done"
  }
}

resource "null_resource" "wait_https_controller_static_standalone" {
  depends_on = [vsphere_virtual_machine.controller_dhcp_standalone]
  count            = (var.dhcp == false && var.avi_cluster== false ? 1 : 0)

  provisioner "local-exec" {
    command = "until $(curl --output /dev/null --silent --head -k https://${vsphere_virtual_machine.controller_static_cluster[count.index].default_ip_address}); do echo 'Waiting for Avi Controllers to be ready'; sleep 10 ; done"
  }
}

resource "local_file" "output_json_file_avi_config" {
  content     = "{\"avi_version\": ${jsonencode(var.avi_version)}, \"avi_tenant\": ${jsonencode(var.avi_tenant)}, \"avi_current_password\": ${jsonencode(var.avi_current_password)}, \"avi_cluster\": ${jsonencode(var.avi_cluster)}, \"avi_dns_server_ips\": ${jsonencode(var.avi_dns_server_ips)}, \"avi_ntp_server_ips\": ${jsonencode(var.avi_ntp_server_ips)}, \"deployment_id\": ${jsonencode(random_string.id.result)}}"
  filename = "../avi_config.json"
}

resource "local_file" "output_json_file_dhcp_cluster" {
  count            = (var.dhcp == true && var.avi_cluster== true ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_cluster.*.default_ip_address)}}"
  filename = "../controllers.json"
}

resource "local_file" "output_json_file_dhcp_standalone" {
  count            = (var.dhcp == true && var.avi_cluster== false ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_dhcp_standalone.*.default_ip_address)}}"
  filename = "../controllers.json"
}

resource "local_file" "output_json_file_static_cluster" {
  count            = (var.dhcp == false && var.avi_cluster== true ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_static_cluster.*.default_ip_address)}}"
  filename = "../controllers.json"
}

resource "local_file" "output_json_file_static_standalone" {
  count            = (var.dhcp == false && var.avi_cluster== false ? 1 : 0)
  content     = "{\"avi_controller_ips\": ${jsonencode(vsphere_virtual_machine.controller_static_standalone.*.default_ip_address)}}"
  filename = "../controllers.json"
}