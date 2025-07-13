output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.medusa_repo.repository_url
}

output "access_instructions" {
  description = "Instructions to access the application"
  value       = "After deployment, get the public IP from ECS service and access at http://<PUBLIC_IP>:9000"
} 