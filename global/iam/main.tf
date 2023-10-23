provider "aws" {
  region = "us-east-2"
}

#resource "aws_iam_user" "example" {
#  count = length(var.user_names)
#  name = var.user_names[count.index]
#}

module "users" {
  source = "github.com/sunpengRvi/webserver-modules//landing-zone/iam-user/?ref=v0.0.8"
  #source = "../../../modules/landing-zone/iam-user"

  #count = length(var.user_names) #This makes module return array
  #user_name = var.user_names[count.index]

  for_each = toset(var.user_names) #This makes module return map
  user_name = each.value
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}
data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}
data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect = "Allow"
    actions = ["cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
  count = var.give_neo_cloudwatch_full_access ? 1 : 0
  user = module.users["neo"].user_name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
  count = var.give_neo_cloudwatch_full_access ? 0 : 1
  user = module.users["neo"].user_name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}