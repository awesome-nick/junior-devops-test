# AWS Elasticsearch cluster to collect logs 
# from nodes of EKS cluster

resource "aws_elasticsearch_domain" "k8s_es_domain" {
  domain_name           = var.cluster_name
  elasticsearch_version = "7.7"

  cluster_config {
    instance_type = var.es_instance_types[0]
    instance_count = 2
    dedicated_master_enabled = false
    zone_awareness_enabled = true
  }

ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = "20"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

    vpc_options {
        subnet_ids = [var.subnets[0], var.subnets[1]]
        security_group_ids = [aws_security_group.es_sg.id]
    }

  tags = {
    Domain = var.cluster_name
  }
    access_policies = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.cluster_name}/*"
        }
    ]
}
POLICY
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

data "aws_caller_identity" "current" {}