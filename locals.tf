locals {
  common_tags = {
    Name            = "${var.cluster_name}-${var.environment}"
    Environment     = var.environment
    ComplianceScope = "Restricted"
    Owner           = "SRE"
    Purpose         = "Cluster VPC"
    TagVersion      = "1.0"
  }

  node_group_node_count_map = {
    node-group-0 = var.environment == "prod" ? 7 : 5,
    node-group-1 = var.environment == "prod" ? 1 : 1,
  }

  node_group_instance_types_map = {
    node-group-0 = "t3.small",
    node-group-1 = "t3.nano",
  }

  gitlab_integration_name = "gitops-${var.environment}"
}
