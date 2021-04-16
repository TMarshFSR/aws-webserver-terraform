provider "aws" {
  region     = "eu-west-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ec2" {
  source = "./ec2"

  net_id            = module.subnets.net_id
  ami_id            = "ami-08bac620dc84221eb"
  instance_type     = "t2.medium"
  av_zone           = "eu-west-1a"
  key_name          = "aws-1"
  subnet_group_name = module.subnets.subnet_group_name
  sec_group_id_sql  = module.vpc.sec_group_id_sql
}


module "subnets" {
  source = "./subnets"

  vpc_id           = module.vpc.vpc_id
  route_id_prod    = module.vpc.route_id_prod
  route_id_private = module.vpc.route_id_private
  sec_group_id     = module.vpc.sec_group_id
  net_private_ips  = ["10.0.1.50"]
  internet_gate    = module.vpc.internet_gate
}

module "vpc" {
  source = "./vpc"

  nat_gate_id = module.subnets.nat_gate_id
}
