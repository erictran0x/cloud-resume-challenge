terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 6.0"
		}
	}
}

provider "aws" {
	region = "us-west-1"
}

module "frontend" {
	source = "./modules/frontend"
}

module "backend" {
	source = "./modules/backend"
}