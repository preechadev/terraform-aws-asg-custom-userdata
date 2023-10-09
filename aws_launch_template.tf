
resource "aws_launch_template" "asg_launch_template" {
  name_prefix   = "${var.environment}-cp-asg-config-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.check_point_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = var.volume_type
      volume_size = var.volume_size
      encrypted   = var.enable_volume_encryption
      kms_key_id  = var.kms_key_arn
    }
  }

  metadata_options {
    instance_metadata_tags = "enabled"
  }

  user_data = base64encode("${data.template_cloudinit_config.user_data.rendered}")

  lifecycle {
    create_before_destroy = true
  }
}
