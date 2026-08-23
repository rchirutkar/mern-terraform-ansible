####################################
# Root Module
####################################

module "vpc" {

  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = var.availability_zones

}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "security_groups" {

  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  allowed_ssh_cidr = var.allowed_ssh_cidr

}

module "web_ec2" {

  source = "./modules/ec2-web"

  project_name = var.project_name
  environment  = var.environment

  subnet_id = module.vpc.public_subnet_ids[0]

  security_group_id = module.security_groups.web_security_group_id

  instance_profile_name = module.iam.instance_profile_name

  key_name = var.key_name

  instance_type = var.instance_type

}

module "mongodb_ec2" {

  source = "./modules/ec2-db"

  project_name = var.project_name
  environment  = var.environment

  subnet_id = module.vpc.private_subnet_ids[0]

  security_group_id = module.security_groups.mongodb_security_group_id

  instance_profile_name = module.iam.instance_profile_name

  key_name = var.key_name

  instance_type = var.instance_type

}


# module "nat_gateway" {
#  source = "./modules/nat-gateway"
#
#  project_name = var.project_name
#  environment  = var.environment
#
#  vpc_id = module.vpc.vpc_id
#
#  public_subnet_id  = module.vpc.public_subnet_ids[0]
#  private_subnet_id = module.vpc.private_subnet_ids[0]
#
#  internet_gateway_id = module.vpc.internet_gateway_id
# }


module "elastic_ip" {

  source = "./modules/elastic-ip"

  instance_id = module.web_ec2.instance_id

  project_name = var.project_name

  environment = var.environment

}