output "sg_lb" {
  value = aws_security_group.lb.id
}

output "sg_api" {
  value = aws_security_group.api.id
}

output "sg_db" {
  value = aws_security_group.db.id
}
