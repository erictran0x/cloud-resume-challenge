terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 6.0"
		}
	}
	backend "s3" {
		bucket 	= "terraform-states-erictran"
		key 		= "erictran.link/terraform.tfstate"
		region 	= "us-west-1"

		assume_role = {
			role_arn = "arn:aws:iam::058264485635:role/terraform"
		}
	}
}

provider "aws" {
	alias 	= "us_west_1"
	region 	= "us-west-1"
}

module "frontend" {
	source = "./modules/frontend"
	
	api = module.backend.api
	website_name = var.website_name
}

module "backend" {
	source = "./modules/backend"

	website_name = var.website_name
}

import {
	to = module.frontend.aws_acm_certificate.ssl_cert
	identity = {
		arn = "arn:aws:acm:us-east-1:058264485635:certificate/67b6963a-106b-4af6-b33a-20fe70b99ccd"
	}
}