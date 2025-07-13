# Security Group for ECS (allows direct access to port 9000)
resource "aws_security_group" "ecs" {
  name        = "medusa-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 9000
    to_port     = 9000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-ecs-sg"
  }
} 