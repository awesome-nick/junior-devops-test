# Deployment of Apache web server to
# the EKS cluster

resource "kubernetes_deployment" "apache_deployment" {
  metadata {
    name = "k8s-apache-deployment"
    labels = {
      App = "k8sApacheExample"
    }
  }

  spec {
    replicas = var.desired_capacity

    selector {
      match_labels = {
        App = "k8sApacheExample"
      }
    }

    template {
      metadata {
        labels = {
          App = "k8sApacheExample"
        }
      }
      spec {
        container {
          image = "httpd:2.4.43"
          name  = "apache"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.http_port

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# Creating a Service to provide LoadBalancer
# using AWS LoadBalancer
resource "kubernetes_service" "apache" {
  metadata {
    name = "k8s-apache"
  }
  spec {
    selector = {
      App = kubernetes_deployment.apache_deployment.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = var.http_port
      target_port = var.http_port
    }
    type = "LoadBalancer"
  }
}
