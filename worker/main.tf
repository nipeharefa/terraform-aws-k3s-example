provider "aws" {
  region = "ap-southeast-1"
}

provider "random" {
  # Configuration options
}

resource "aws_spot_instance_request" "worker" {
  count                  = 2
  ami                    = "ami-01581ffba3821cdf3"
  instance_type          = "t3.nano"
  block_duration_minutes = 60
  key_name               = var.ssh
  security_groups        = ["ec2-group"]
  tags = {
    Name = "worker"
  }
}

resource "null_resource" "worker" {
  count = 2
  triggers = {
    cluster_instance_ids = join(",", aws_spot_instance_request.worker.*.public_ip)
  }

  provisioner "file" {
    source = "worker/join.sh"
    destination = "/home/ubuntu/join.sh"
    
    connection {
      host = aws_spot_instance_request.worker[count.index].public_ip
      user = "ubuntu"
    }
  }

  provisioner "remote-exec" {
    connection {
      host = element(aws_spot_instance_request.worker[count.index].*.public_ip, 0)
      user = "ubuntu"
    }

    inline = [
      "sudo hostnamectl set-hostname node-pool",
      "chmod +x /home/ubuntu/join.sh",
      "sh /home/ubuntu/join.sh"
    ]
  }
}
