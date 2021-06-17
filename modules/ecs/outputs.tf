output "sg_lb" {
  value = aws_security_group.lb.id
}

output "sg_api" {
  value = aws_security_group.api.id
}

output "sg_db" {
  value = aws_security_group.db.id
}

output "lb_dns" {
  value = aws_lb.lb.dns_name
}

output "asg_vpc_zone_identifier" {
  value = aws_autoscaling_group.asg.vpc_zone_identifier
}

output "asg_availability_zones" {
  value = aws_autoscaling_group.asg.availability_zones
}
