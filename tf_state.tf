terraform {
  required_version = ">= 0.12"
  backend "s3" {
    encrypt        = true
    bucket         = "k8s.awesomenick.com"
    region         = "eu-central-1"
    key            = "tf/terraform.tfstate"
    dynamodb_table = "k8s-tf-state"
  }
}
