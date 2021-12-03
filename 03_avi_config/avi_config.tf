resource "avi_cluster" "aws_cluster" {
  count            = (var.avi_cluster== true ? 3 : 0)
  name = var.cluster_name
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

resource "avi_systemconfiguration" "avi_system" {
  common_criteria_mode      = false
  uuid                      = "default-uuid"
  welcome_workflow_complete = true
  dns_configuration {
    server_list {
      addr = var.dns_servers[0]
      type = "V4"
    }
    server_list {
      addr = var.dns_servers[1]
      type = "V4"
    }
    server_list {
      addr = var.dns_servers[2]
      type = "V4"
    }
    search_domain = var.search_domain #"remo.local"
  }
  email_configuration {
    disable_tls      = var.mail_server_tls #false
    from_email       = var.email
    mail_server_name = var.mail_server      #"localhost"
    mail_server_port = var.mail_server_port #25
    smtp_type        = var.mail_type        #"SMTP_LOCAL_HOST"
  }
  linux_configuration {
    motd   = ""
    banner = var.banner
  }
  global_tenant_config {
    se_in_provider_context       = true
    tenant_access_to_provider_se = true
    tenant_vrf                   = false
  }

  ntp_configuration {
    ntp_servers {
      key_number = 1
      server {
        addr = var.ntp_servers[0]
        type = "DNS"
      }
    }
    ntp_servers {
      key_number = 1
      server {
        addr = var.ntp_servers[1]
        type = "DNS"
      }
    }
    ntp_servers {
      key_number = 1
      server {
        addr = var.ntp_servers[2]
        type = "DNS"
      }
    }
    ntp_servers {
      key_number = 1
      server {
        addr = var.ntp_servers[3]
        type = "DNS"
      }
    }
  }
}


resource "avi_backupconfiguration" "backup_config" {
  name       = "Backup-Configuration"
  tenant_ref = "admin"
  #tenant_ref              = data.avi_tenant.default_tenant.id
  save_local             = true
  maximum_backups_stored = 4
  backup_passphrase      = var.avi_password
  configpb_attributes {
    version = 1
  }
}