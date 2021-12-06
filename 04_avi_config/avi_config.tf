resource "avi_systemconfiguration" "avi_system" {
  common_criteria_mode      = false
  uuid                      = "default-uuid"
  welcome_workflow_complete = true

  dynamic dns_configuration {
    for_each = flatten(split(",", replace(var.avi_dns_servers, " ", "")))
    content {
      server_list {
        addr = dns_configuration.value
        type = "V4"
      }
    }
  }

  global_tenant_config {
    se_in_provider_context       = true
    tenant_access_to_provider_se = true
    tenant_vrf                   = false
  }

  dynamic ntp_configuration {
    for_each = flatten(split(",", replace(var.avi_ntp_servers, " ", "")))
    content {
      ntp_servers {
        key_number = 1
        server {
          addr = ntp_configuration.value
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