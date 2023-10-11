provider "aws" {
  region = "us-east-2"
}

#resource "aws_iam_user" "example" {
#  count = length(var.user_names)
#  name = var.user_names[count.index]
#}

module "users" {
  source = "github.com/sunpengRvi/webserver-modules//landing-zone/iam-user/?ref=v0.0.5"
  #source = "../../../modules/landing-zone/iam-user"

  #count = length(var.user_names) #This makes module return array
  #user_name = var.user_names[count.index]

  for_each = toset(var.user_names) #This makes module return map
  user_name = each.value
}