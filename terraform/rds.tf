resource "aws_db_subnet_group" "medusa" {
  name       = "medusa-db-subnet-group"
  subnet_ids = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  tags = {
    Name = "medusa-db-subnet-group"
  }
}

resource "aws_db_instance" "medusa" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  db_name              = "medusadb"
  username             = "medusauser"
  password             = "YourStrongPassword123!"
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
  publicly_accessible  = true

  vpc_security_group_ids = [aws_security_group.ecs.id]
  db_subnet_group_name   = aws_db_subnet_group.medusa.name

  tags = {
    Name = "medusa-db"
  }
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.medusa.endpoint
}