# Reuse the role + instance profile the console created ("Create default role").
# We look it up rather than create a new one: this account doesn't let us tag
# instance profiles or detach role policies, which Terraform would need.
data "aws_iam_instance_profile" "ecs_instance" {
  name = "ecsInstanceRole"
}