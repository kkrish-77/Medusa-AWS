# ECR Repository
resource "aws_ecr_repository" "medusa_repo" {
  name                 = "medusa-store"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "medusa-ecr-repo"
  }
} 