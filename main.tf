provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_launch_template" "namd_dev" {
  name_prefix            = "namd_dev"
  image_id               = "${var.centos_ami}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name         = "${var.key_name}"
  #subnet_id = "subnet-0095f47a"
  block_device_mappings {
    device_name = "/dev/sdh"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  #disable_api_termination              = true
  #ebs_optimized                        = true
  instance_initiated_shutdown_behavior = "terminate"

  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "namd_asg" {
  availability_zones = ["${var.availability_zones}"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.namd_dev.id}"
    version = "$$Latest"
  }
}
