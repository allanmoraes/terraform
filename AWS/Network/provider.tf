provider "aws" {
    shared_config_files      = ["~/.aws/conf"]
    shared_credentials_files = ["~/.aws/credentials"]
    region                   = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "tf-state-service"
        key     = "infrastructure/network/terraform.tfstate"
        encrypt = "true"
        region  = "us-east-1"
    }
}