data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
locals {
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    var.az_count
  )

  private_subnets = {
    for index, az in local.availability_zones :
    az => cidrsubnet(
      var.vpc_cidr,
      4,
      index
    )
  }

  public_subnets = {
    for index, az in local.availability_zones :
    az => cidrsubnet(
      var.vpc_cidr,
      4,
      index + var.az_count
    )
  }

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
module "network" {
  source = "../../modules/network"

  name = "${var.project_name}-${var.environment}"

  vpc_cidr = var.vpc_cidr

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  single_nat_gateway = var.single_nat_gateway

  tags = local.common_tags
}
module "eks" {
  source = "../../modules/eks"

  cluster_name = "${var.project_name}-${var.environment}"

  kubernetes_version = var.kubernetes_version

  private_subnet_ids = (
    module.network.private_subnet_ids_list
  )

  cluster_admin_principal_arn = (
    var.cluster_admin_principal_arn
  )

  endpoint_public_access = true

  endpoint_public_access_cidrs = (
    var.cluster_endpoint_public_access_cidrs
  )

  node_instance_types = (
    var.node_instance_types
  )

  node_capacity_type = "ON_DEMAND"

  node_min_size     = 2
  node_desired_size = 2
  node_max_size     = 4

  tags = local.common_tags
}
module "ecr" {
  source = "../../modules/ecr"

  repository_name = (
    "${var.project_name}/vaultwarden"
  )

  force_delete = true

  scan_on_push = true

  max_images = 30

  untagged_expiration_days = 1

  tags = local.common_tags
}