output "master_ip" {
  value = aws_spot_instance_request.master.*.public_ip
}

output "lb_instance_ips" {
  value = aws_spot_instance_request.lb.*.public_ip
}