variable "environment" {
  description = "Environment"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  default     = "gitops"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster version"
  default     = "1.20"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "gitlab_integration_enabled" {
  description = "Enable GitLab integration"
  default     = true
  type        = bool
}
