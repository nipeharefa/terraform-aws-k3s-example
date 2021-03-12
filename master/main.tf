terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
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

resource "aws_spot_instance_request" "master" {
  ami                    = "ami-01581ffba3821cdf3"
  instance_type          = var.instance_type
  block_duration_minutes = 60
  key_name               = var.ssh
  security_groups        = ["ec2-group"]
  tags = {
    Name = "master"
  }

}

resource "null_resource" "master" {
  triggers = {
    cluster_instance_ids = join(",", aws_spot_instance_request.master.*.public_ip)
  }

  provisioner "remote-exec" {
    connection {
      # host = aws_spot_instance_request.master.public_dns
      host = element(aws_spot_instance_request.master.*.public_ip, 0)
      user = "ubuntu"
    }

    inline = [
      "curl -sfL https://get.k3s.io | sh -"
    ]
  }
}
