output "sg_lb" {
  description = "The security group for the load balancer."
  value       = aws_security_group.lb.id
}

output "sg_api" {
  description = "The security group for the API."
  value       = aws_security_group.api.id
}

output "sg_db" {
  description = "The security group for the database."
  value       = aws_security_group.db.id
}
