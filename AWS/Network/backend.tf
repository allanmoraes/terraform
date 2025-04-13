terraform {
  backend "s3" {
    bucket         = "platform-terraform-state"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "platform-terraform-locks"
    role_arn       = "arn:aws:iam::278250362788:role/GitActionsNetwork"
  }
}