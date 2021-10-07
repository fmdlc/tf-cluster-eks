provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  # tflint-ignore: terraform_deprecated_index
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# tflint-ignore: terraform_naming_convention
module "eks-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}-${var.environment}"
  cluster_version = var.cluster_version
  subnets         = [for subnet in concat(data.terraform_remote_state.vpc.outputs.vpc_public_subnets, data.terraform_remote_state.vpc.outputs.vpc_private_subnets) : subnet]
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 10
  }

  node_groups = {
    node-group-0 = {
      min_capacity     = ceil(lookup(local.node_group_node_count_map, "node-group-0", 3) / 2)
      max_capacity     = lookup(local.node_group_node_count_map, "node-group-0", 3)
      desired_capacity = lookup(local.node_group_node_count_map, "node-group-0", 3)
      instance_types   = [lookup(local.node_group_instance_types_map, "node-group-0", "t3.small")]

      k8s_labels = {
        Environment = var.environment
      }

      update_config = {
        max_unavailable_percentage = 50
      }
    },

    node-group-1 = {
      min_capacity     = 0
      max_capacity     = lookup(local.node_group_node_count_map, "node-group-1", 1)
      desired_capacity = lookup(local.node_group_node_count_map, "node-group-1", 1)
      instance_types   = [lookup(local.node_group_instance_types_map, "node-group-1", "t3.nano")]

      k8s_labels = {
        Environment = var.environment
      }

      taints = [
        {
          key    = "dedicated"
          value  = "cheap_nodes"
          effect = "NO_SCHEDULE"
        }
      ]

      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }

  tags = local.common_tags
}
