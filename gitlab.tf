resource "kubernetes_service_account" "gitlab" {
  metadata {
    name      = "gitlab-kubernetes-integration"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "cluster-eks"
    }
  }
}

resource "kubernetes_cluster_role_binding" "gitlab" {
  metadata {
    name = kubernetes_service_account.gitlab.metadata[0].name
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/name"       = "cluster-eks"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.gitlab.metadata[0].name
    namespace = kubernetes_service_account.gitlab.metadata[0].namespace
  }
}

data "kubernetes_secret" "gitlab" {
  metadata {
    name      = kubernetes_service_account.gitlab.default_secret_name
    namespace = kubernetes_service_account.gitlab.metadata[0].namespace
  }
}

resource "gitlab_group_cluster" "eks" {
  group             = "training-gitops"
  name              = local.gitlab_integration_name
  enabled           = var.gitlab_integration_enabled
  environment_scope = local.gitlab_integration_name
  managed           = false

  kubernetes_api_url            = data.aws_eks_cluster.cluster.endpoint
  kubernetes_ca_cert            = data.kubernetes_secret.gitlab.data["ca.crt"]
  kubernetes_token              = data.kubernetes_secret.gitlab.data.token
  kubernetes_authorization_type = "rbac"
}
