resource "aws_security_group" "catapp" {
  name        = "${var.project}-sg"
  description = "Allow HTTP to the cat app on port 8888"
  vpc_id      = data.aws_vpc.default.id
}

# AWS-managed list of the IP ranges CloudFront uses to reach origins
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Inbound: app port from CloudFront only, so visitors can't bypass HTTPS
resource "aws_vpc_security_group_ingress_rule" "http_ipv4" {
  security_group_id = aws_security_group.catapp.id
  ip_protocol       = "tcp"
  from_port         = var.host_port
  to_port           = var.host_port
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront.id
}

# Outbound: allow everything — the instance must reach ECS and ECR to get its tasks and image
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.catapp.id
  ip_protocol       = "-1" # -1 means all protocols and ports
  cidr_ipv4         = "0.0.0.0/0"
}
