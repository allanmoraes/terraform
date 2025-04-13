terraform {
  backend "s3" {
    bucket         = "allan-terraform-state"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    #dynamodb_table = "allan-terraform-locks"
  }
}