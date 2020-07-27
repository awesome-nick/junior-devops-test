provider "aws" {
  region = var.region
  version = "~> 2.70"

}

provider "kubernetes" {
  load_config_file = "false"
  host = aws_eks_cluster.aws_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.aws_eks.token
}