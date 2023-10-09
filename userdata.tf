
// user_data

data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  // Main cloud-config configuration file.
  part {
    filename     = "cloud-config"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/asg_userdata.yaml", {
      // User data script's arguments
      PasswordHash          = local.gateway_password_hash_base64,
      EnableCloudWatch      = var.enable_cloudwatch,
      EnableInstanceConnect = false,
      Shell                 = "/bin/bash",
      SICKey                = local.gateway_SICkey_base64,
      AllowUploadDownload   = true,
      BootstrapScript       = local.gateway_bootstrap_script64,
      OsVersion             = local.version_split
      NTPPrimary            = "1.1.1.1"
    })
  }

  // Gaia config
  part {
    filename     = "gw_gaia_config.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/gw_gaia_config.sh", {
      user_hash      = var.user_hash
      nr_key         = var.nr_key
      snmp_community = var.snmp_community
    })
  }
}
