resource "avi_systemconfiguration" "avi_system" {
  common_criteria_mode      = false
  uuid                      = "default-uuid"
  welcome_workflow_complete = true

  dns_configuration {
    dynamic server_list {
      for_each = flatten(split(",", replace(var.avi_dns_server_ips, " ", "")))
      content {
        addr = server_list.value
        type = "V4"
      }
    }
  }

  global_tenant_config {
    se_in_provider_context       = true
    tenant_access_to_provider_se = true
    tenant_vrf                   = false
  }

  ntp_configuration {
     ntp_servers {
        dynamic server {
          for_each = flatten(split(",", replace(var.avi_ntp_server_ips, " ", "")))
          content {
          addr = server.value
          type = "V4"
        }
      }
    }
  }
}


resource "avi_backupconfiguration" "backup_config" {
  name       = "Backup-Configuration"
  tenant_ref = var.avi_tenant
  save_local             = true
  maximum_backups_stored = 4
  backup_passphrase      = var.avi_password
  configpb_attributes {
    version = 1
  }
}