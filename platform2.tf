resource "helm_release" "platform2" {

  name                = "argocd-platform-2"
  repository          = "https://argoproj.github.io/argo-helm"
  chart               = "argo-cd"
  version             = var.argocd_chart_version
  namespace           = kubernetes_namespace.platform2.metadata.0.name
  values = [
    templatefile("${path.module}/argocd-values.yaml", {
      argo_url                             = "platform-1.argocd.web",
      image_repo                           = var.image_repo,
      image_tag                            = var.image_tag,
      controller_replicas                  = 1
      argocd_apps_namespace                = kubernetes_namespace.platform2.metadata.0.name
    })
  ]

}

resource "kubernetes_namespace" "platform2" {

  metadata {
    name = "platform-2"
    labels = {
      "field.cattle.io/projectId" = ""
    }
    annotations = {
      "cattle.io/status"                          = ""
      "lifecycle.cattle.io/create.namespace-auth" = ""
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["cattle.io/status"],
      metadata.0.labels["field.cattle.io/projectId"],
      metadata.0.annotations["lifecycle.cattle.io/create.namespace-auth"],


    ]
  }
}

resource "helm_release" "config-2" {
  depends_on = [helm_release.platform2]
  name       = "argocd-config-2"
  chart      = "${path.module}/argocd"
  namespace  = kubernetes_namespace.platform2.metadata.0.name
  set {
    name  = "namespace"
    value = kubernetes_namespace.platform2.metadata.0.name

  }

}