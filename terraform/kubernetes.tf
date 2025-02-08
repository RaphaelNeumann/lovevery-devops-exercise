
resource "kubernetes_namespace" "application_namespace" {
  metadata {
    name = var.application_namespace
  }
}

resource "kubernetes_secret" "application-envs" {
  metadata {
    name      = "${var.application_name}-envs"
    namespace = var.application_namespace
  }

  data = jsondecode(data.aws_secretsmanager_secret_version.env.secret_string)
}

resource "helm_release" "application" {
  name      = "${var.environment}-${var.application_name}"
  namespace = var.application_namespace

  chart = "${path.module}/../.k8s/charts/raill-app-blueprint"

  values = [
    file("${path.module}/../.k8s/values/common.yaml"),
    file("${path.module}/../.k8s/values/${var.environment}.yaml"),
  ]

  depends_on = [
    kubernetes_namespace.application_namespace, 
    kubernetes_secret.application-envs
  ]
}

