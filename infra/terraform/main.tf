terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  vpc_cidr_block = var.vpc_cidr_block
  public_subnets = var.public_subnets
}

resource "aws_key_pair" "media_host" {
  key_name   = var.key_pair_name
  public_key = file(var.ssh_public_key_path)
}
