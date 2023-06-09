data "aws_caller_identity" "current" {}

locals {
  name       = "mnorman-io"
  region     = "us-west-2"
  account_id = data.aws_caller_identity.current.account_id
}