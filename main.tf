terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "null" {
  # Configuration options
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_spot_instance_request" "lb" {
  ami                    = "ami-01581ffba3821cdf3"
  instance_type          = var.instance_type
  block_duration_minutes = 120
  key_name               = var.ssh
  security_groups        = ["ec2-group"]
  tags = {
    Name = "lb"
  }
}
