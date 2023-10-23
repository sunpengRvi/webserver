provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-psun-20230915"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-psun-20230915"
    encrypt = true
  }
}

module "webserver_cluster" {
  source = "github.com/sunpengRvi/webserver-modules//services/webserver-cluster?ref=v0.0.9"

  cluster_name = "webserver-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-psun-20230915"
  db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
  instance_type = "m4.large"
  min_size = 2
  max_size = 10
  enable_autoscaling = true

  custom_tags = {
    Owner = "team-foo"
    ManagedBy = "terraform"
  }
}
