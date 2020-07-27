# Security Group to limit access to AWS Elasticsearch Cluster
data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "es_sg" {
  name        = "elasticsearch-${var.cluster_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.main.cidr_block,
      var.my_public_ip
    ]
  }
}