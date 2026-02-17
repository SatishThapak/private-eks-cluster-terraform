module "vpc" {
  source          = "./modules/networking"
  cidr_block      = var.cidr_block
  vpc_name        = var.vpc_name
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  project_name    = var.project_name
  environment     = var.environment
}

module "security_group" {
  source       = "./modules/security_groups"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

module "iam_roles" {
  source       = "./modules/iam_roles"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  iam_role     = var.iam_role
}

module "aws_jump_host" {
  source                = "./modules/jump_host"
  project_name          = var.project_name
  instance_name         = var.instance_name
  instance_type         = var.instance_type
  environment           = var.environment
  ami_id                = var.ami_id
  region                = var.region
  subnet_id             = module.vpc.public_subnet_ids[0]
  iam_role              = module.iam_roles.jump_host_role_name
  security_group_id     = module.security_group.security_group_id
  instance_profile_name = module.iam_roles.jump_host_instance_profile_name
  instance_profile_id   = module.iam_roles.jump_host_instance_profile_id
}

module "eks_cluster" {
  source           = "./modules/eks_cluster"
  project_name     = var.project_name
  environment      = var.environment
  cluster_role_arn = module.iam_roles.eks_master_role_arn
  worker_role_arn  = module.iam_roles.eks_worker_role_arn
  subnet_ids       = module.vpc.private_subnet_ids
  instance_type    = "t2.medium"
  desired_size     = 2
  min_size         = 1
  max_size         = 3
}


