data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "tty0"
    workspaces = {
      name = "cluster-vpc"
    }
  }
}
