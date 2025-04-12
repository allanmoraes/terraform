terraform {
  backend "s3" {
    bucket         = "platform-terraform-state"
    key            = "network/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = "platform-terraform-locks"
    role_arn       = "CROSS-ACCOUNT"
  }
}