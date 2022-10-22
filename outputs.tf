output "arn" {
  value       = aws_ecr_repository.this.arn
  description = "Full ARN of the repository"
}

output "registry_id" {
  value       = aws_ecr_repository.this.registry_id
  description = "The registry ID of the repository"
}

output "repository_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "The URL of the repository"
}