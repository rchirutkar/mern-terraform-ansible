output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "web_public_ip" {
  value = module.web_ec2.public_ip
}

output "web_private_ip" {
  value = module.web_ec2.private_ip
}

output "mongodb_private_ip" {
  value = module.mongodb_ec2.private_ip
}

# ansible outputs

output "web_instance_name" {
  value = module.web_ec2.instance_name
}

output "mongo_instance_name" {
  value = module.mongodb_ec2.instance_name
}

# Elasti ip
output "application_url" {
  value = "http://${module.elastic_ip.elastic_ip}"
}