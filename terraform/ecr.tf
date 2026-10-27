# Same as: ECR console → Create repository
resource "aws_ecr_repository" "catapp" {
  name         = var.project
  force_delete = true # lets `terraform destroy` delete the repo even if it still has images
}