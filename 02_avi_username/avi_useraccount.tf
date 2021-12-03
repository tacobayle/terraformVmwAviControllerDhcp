resource "avi_useraccount" "avi_user" {
  username     = "admin"
  old_password = var.avi_current_password
  password     = var.avi_password == null ? random_string.avi_password_random.result : var.avi_password
}

resource "random_string" "avi_password_random" {
  length           = 8
  special          = true
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "%$&"
}

resource "local_file" "output_passwd_file" {
  count   = var.avi_password == null ? 1 : 0
  content     = "{\"avi_password\": ${jsonencode(random_string.avi_password_random.result)}}"
  filename = "../03_avi_config/inputs.json"
}