terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 6.0"
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