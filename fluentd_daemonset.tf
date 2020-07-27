# Creating the DaemonSet to add fluentd pods on the nodes
# of EKS cluster to export logs to Elasticseach cluster

resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = kubernetes_namespace.kube-logging.metadata.0.name
    labels = {
      App = "k8sApacheFluentd"
    }
  }

  spec {
    selector {
      match_labels = {
        App = "k8sApacheFluentd"
      }
    }

    template {
      metadata {
        labels = {
          App = "k8sApacheFluentd"
        }
      }

      spec {
        container {
          image = "fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1"
          name  = "fluentd"

          env {
            name  = "FLUENT_ELASTICSEARCH_HOST"
            value = aws_elasticsearch_domain.k8s_es_domain.endpoint
          }
          env {
            name  = "FLUENT_ELASTICSEARCH_PORT"
            value = "9200"
          }
          env {
            name  = "FLUENT_ELASTICSEARCH_SCHEME"
            value = "https"
          }
          env {
            name  = "FLUENT_ELASTICSEARCH_USER"
            value = var.elastic_user
          }
          env {
            name  = "FLUENT_ELASTICSEARCH_PASSWORD"
            value = var.elastic_passwd
          }
          env {
            name  = "KUBERNETES_SERVICE_HOST"
            value = replace(aws_eks_cluster.aws_eks.endpoint, "https://", "")
          }
          env {
            name  = "KUBERNETES_SERVICE_PORT"
            value = "8443"
          }
        }
      }
    }
  }
}

resource "kubernetes_namespace" "kube-logging" {
  metadata {
    annotations = {
      name = "kube-logging"
    }

    labels = {
      App = "k8sApacheFluentd"
    }

    name = "kube-logging"
  }
}

resource "kubernetes_service_account" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = kubernetes_namespace.kube-logging.metadata.0.name
    labels = {
      App = "k8sApacheFluentd"
    }
  }
  automount_service_account_token = "true"
}


resource "kubernetes_cluster_role" "fluentd" {
  metadata {
    name = "fluentd"
    labels = {
      App = "k8sApacheFluentd"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}


resource "kubernetes_cluster_role_binding" "fluentd" {
  metadata {
    name = "fluentd"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fluentd"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "fluentd"
    namespace = "kube-logging"
  }
}


