# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "medusa-cluster"

  tags = {
    Name = "medusa-cluster"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "medusa"
      image = "kkrish77/medusa-app:latest"
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "MEDUSA_ADMIN_ONBOARDING_TYPE", value = "default" },
        { name = "STORE_CORS", value = "http://localhost:8000,https://docs.medusajs.com" },
        { name = "ADMIN_CORS", value = "http://localhost:5173,http://localhost:9000,https://docs.medusajs.com" },
        { name = "AUTH_CORS", value = "http://localhost:5173,http://localhost:9000,http://localhost:8000,https://docs.medusajs.com" },
        { name = "JWT_SECRET", value = "f46b7df7c79b67b9692374f69cf5b834316edd1a4041d47f7226108f09b20486" },
        { name = "COOKIE_SECRET", value = "a6bf071c022c10d291203583d6fd995e12277f6c67063a50c27ca29cd6a4dc2c" },
        { name = "DATABASE_URL", value = "postgres://medusauser:YourStrongPassword123!@terraform-20250713134507130700000001.c8t6y6agg9l8.us-east-1.rds.amazonaws.com:5432/medusadb?ssl=true" },
        { name = "NODE_TLS_REJECT_UNAUTHORIZED", value = "0" },
        { name = "MEDUSA_LOG_LEVEL", value = "verbose" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/medusa"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "medusa-task-definition"
  }
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name = "medusa-service"
  }
} 