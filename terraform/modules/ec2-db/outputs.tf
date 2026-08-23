output "instance_id" {
  value = aws_instance.mongodb.id
}

output "private_ip" {
  value = aws_instance.mongodb.private_ip
}

output "instance_name" {
  value = aws_instance.mongodb.tags.Name
}