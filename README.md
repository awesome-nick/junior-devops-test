# junior-devops-test
Test: Run Kubernetes cluster on AWS with EFK stack
==================================================

Prerequisites:
1. Install & configure AWS CLI & terraform
2. Setup S3 bucket for terraform backend [(tf_state storage)](https://www.terraform.io/docs/backends/types/s3.html)
3. Setup [DynamoDB for locking of terraform state](https://www.terraform.io/docs/backends/types/s3.html)
4. Setup all required variables except the sensitive ones in the variables.tf (e.g. Elasticsearch user & password)

Run 
----------------
1. Initialize the terraform working directory:
~~~yaml
  terraform init
~~~
2. Create a plan & check if everything is OK:
~~~yaml
  terraform plan
~~~
3. Finally create the infrastructure by applying the plan & setting the password etc:
~~~yaml
  terraform apply -var='elastic_user=user' -var='elastic_passwd=password'
~~~
4. If needed, infrastructure could be destroyed later with
~~~yaml
  terraform destroy
~~~
