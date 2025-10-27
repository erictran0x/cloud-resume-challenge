resource "aws_s3_bucket" "website_bucket" {
	bucket = var.website_bucket_name
}