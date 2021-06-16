variable "project" {
  description = "The project to be provisioned."
  default     = "Facilittei"
}

variable "region" {
  description = "The instance region to be provisioned."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The environment provisioned."
}

variable "cidr" {
  description = "The IPv4 CIDR block of the VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The list of availability zones to be provisioned."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "image_id" {
  description = "The Amazon Machine Image ID."
  default     = "ami-0aeeebd8d2ab47354"
}

variable "instance_type" {
  description = "The Amazon Machine Image instance type."
  default     = "t2.micro"
}
