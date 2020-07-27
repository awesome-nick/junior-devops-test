output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws_eks.endpoint
}

output "apache_lb_hostname" {
  value = kubernetes_service.apache.load_balancer_ingress[0].hostname
}

output "es_endpoint" {
  value = aws_elasticsearch_domain.k8s_es_domain.endpoint
}

output "es_kibana_endpoint" {
  value = aws_elasticsearch_domain.k8s_es_domain.kibana_endpoint
}