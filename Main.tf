terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }

  required_version = ">= 0.14.9"
}

#Provider profile and region in which all the resources will creates
provider "aws" {
  profile = "default"
  region  = "eu-north-1"
}