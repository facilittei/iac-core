data "aws_iam_policy_document" "agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "agent" {
  name               = "${lower(var.project)}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.agent.json

  tags = {
    Name        = "IAM Role"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}


resource "aws_iam_role_policy_attachment" "agent" {
  role       = "aws_iam_role.agent.name"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "agent" {
  name = "${lower(var.project)}-${var.environment}"
  role = aws_iam_role.agent.name

  tags = {
    Name        = "IAM Profile"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}
