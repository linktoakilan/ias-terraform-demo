output "aws_instance_id" {
  value = aws_instance.ec2.id
}
output "aws_instance_publicip" {
  value = aws_instance.ec2.public_ip
}
output "aws_instance_publicdns" {
  value = aws_instance.ec2.public_dns
}