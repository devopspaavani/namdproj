output "aws_instance_id" {
  value = "${aws_launch_template.namd_dev.id}"
}
