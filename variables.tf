#  Self explanatory :)
variable "region" {
  default     = "eu-central-1"
}

variable "cluster_name" {
  default = "k8s-apache-cluster"
}

variable "node_group_name" {
  default = "apache-node-group"
}

variable "disk_size" {
  default = "10"
}

variable "subnets" {
  default = ["subnet-2e03f252", "subnet-7c8f3516", "subnet-b438fcf8"]
}

variable "vpc_id" {
  default = "vpc-da994bb0"
}

variable "env" {
  description = "type of current environment"
  default = "testing"
}

variable "desired_capacity" {
  default = "3"
}

variable "max_size" {
  default = "5"
}

variable "min_size" {
  default = "1"
}

variable "http_port" {
  default     = "80"
}

variable "instance_types" {
  default     = ["t2.micro"]
}

variable "es_instance_types" {
  default = ["t2.small.elasticsearch"]
}

variable "my_public_ip" {
  default     = "1.0.0.0.0/32"
}
variable "ami" {
  default     = "ami-072571fe035924fa7"
}

variable "elastic_user"{}

variable "elastic_passwd" {}