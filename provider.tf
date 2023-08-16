
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_config_files      = ["/home/oem/.aws/config"]
  shared_credentials_files = ["/home/oem/.aws/credentials"]
  profile                  = "Aditya_Kamble"
}
