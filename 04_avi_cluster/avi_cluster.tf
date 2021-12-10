resource "avi_cluster" "avi_cluster" {
  count            = (var.avi_cluster== true ? 3 : 0)
  name = "cluster_avi_tf_${var.deployment_id}"
  nodes {
    ip {
      type = "V4"
      addr = var.avi_controller_ips.0
    }
    name = "node01"
  }
  nodes {
    ip {
      type = "V4"
      addr = var.avi_controller_ips.1
    }
    name = "node02"
  }
  nodes {
    ip {
      type = "V4"
      addr = var.avi_controller_ips.2
    }
    name = "node03"
  }
}