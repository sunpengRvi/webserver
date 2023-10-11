provider "aws" {
  region = "us-east-2"

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner = "team-foo"
      ManagedBy = "Terraform"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-psun-20230915"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-psun-20230915"
    encrypt = true
  }
}

module "webserver_cluster" {
  source = "github.com/sunpengRvi/webserver-modules//services/webserver-cluster?ref=v0.0.3"
  //source = "../../../../modules/services/webserver-cluster"

  cluster_name = "webserver-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-psun-20230915"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2

  custom_tags = {
    Owner = "team-foo"
    ManagedBy = "terraform"
  }
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id =module.webserver_cluster.alb_security_group_id
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}