output "public_ip" {
  value = aws_instance.our_ec2_instance.public_ip
}