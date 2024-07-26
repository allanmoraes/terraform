# ----- AWS TAGS -----
variable "owner_team" {
    default = "platform"
}

variable "cost_center" {
    default = "infrastructure"
}

variable "repository" {
    default = "https://github.com/allanmoraes/terraform"
}

# ----- AWS -----
variable "aws_region" {
    description = "The AWS region"
    default     = "us-east-1"
}

variable "aws_az" {
 type        = list(string)
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# ----- VPC -----
variable "vpc_cidr" {
    type        = string
    description = "VPC CIDR value"
    default     = "10.0.0.0/16" 
}

# ----- SUBNET -----
variable "public_subnet_cidrs" {
    type        = list(string)
    description = "Public Subnet CIDR values"
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "private_subnet_cidrs" {
    type        = list(string)
    description = "Private Subnet CIDR values"
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}