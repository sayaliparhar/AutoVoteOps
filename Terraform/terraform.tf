terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./Ec2_Instances"

  # subnet_ids
  pub_sub_1 = module.vpc.public_subnet_1
  priv_sub_1 = module.vpc.private_subnet_1
  priv_sub_2 = module.vpc.private_subnet_2
  priv_sub_3 = module.vpc.private_subnet_3

  # security_group_ids
  jenkins_vm_sg = module.vpc.sg-Jenkins
  k8s_master_vm_sg = module.vpc.sg-k8s-master
  k8s_worker_vm_sg = module.vpc.sg-k8s-worker
  rds_sg = module.vpc.sg-rds
  alb_sg = module.vpc.sg-alb

  # vpc-id
  vpc_id = module.vpc.vpc-id

  depends_on = [ module.vpc ]
}

module "RDS" {
  source = "./RDS"

  private_sub_2 = module.vpc.private_subnet_2
  private_sub_3 = module.vpc.private_subnet_3
  rds_sg = module.vpc.sg-rds

  depends_on = [ module.vpc ]
}