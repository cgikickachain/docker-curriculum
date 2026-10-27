# Find the latest ECS-optimised Amazon Linux 2023 AMI (the console's default)
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

# The "recipe" for each instance: AMI, size, role, network, startup script
resource "aws_launch_template" "catapp" {
  name          = "${var.project}-lt"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.ecs_instance.arn
  }

  network_interfaces {
    associate_public_ip_address = true # "Auto-assign public IP: Turn on"
    security_groups             = [aws_security_group.catapp.id]

  }

  # Tell the ECS agent which cluster to join
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.catapp.name}" >> /etc/ecs/ecs.config
  EOF
  )

  metadata_options {
    http_tokens = "required" # IMDSv2, same as the console instance
  }

  # default_tags does NOT reach instances launched by an ASG — tag them here
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project}-instance"
      owner   = var.owner
      project = var.project
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      owner   = var.owner
      project = var.project
    }
  }
}

# Keeps exactly 1 instance running from that recipe ("Desired capacity" min 1 / max 1)
resource "aws_autoscaling_group" "catapp" {
  name                = "${var.project}-asg"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [data.aws_subnet.a.id]

  launch_template {
    id      = aws_launch_template.catapp.id
    version = "$Latest"
  }
}
