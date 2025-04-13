locals {
    context = {
        prod = {
            project_name     = "myproject"
            environment      = "prod"
            owner            = "ProdTeam"
            git_repo         = "https://github.com/company/myproject.git"
            cost_center      = "PROD-456"
            aws_region       = "us-east-1"
            vpc_cidr         = "10.1.0.0/16"
            public_subnet_cidrs  = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
            private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
        }
    }
}