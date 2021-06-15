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
