locals {
	mime_types = {
		"html" = "text/html"
		"css"  = "text/css"
		"js"   = "application/javascript"
		"png"  = "image/png"
		"jpg"  = "image/jpeg"
		"svg"  = "image/svg+xml"
	}
}

resource "aws_s3_bucket" "this" {
	bucket = var.website_name
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
	bucket = aws_s3_bucket.this.id
	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect    = "Allow"
				Action    = [
					"s3:GetObject"
				]
				Principal = "*"
				Resource  = "${aws_s3_bucket.this.arn}/*"
			}
		]
	})
}

resource "aws_s3_bucket_versioning" "this" {
	bucket = aws_s3_bucket.this.id

	versioning_configuration {
		status = "Enabled"
	}
}

resource "aws_s3_bucket_website_configuration" "this" {
	bucket = aws_s3_bucket.this.id

	index_document {
		suffix = "index.html"
	}
}

resource "aws_s3_object" "website_files" {
	for_each = fileset("${path.module}/s3_site", "**")

	bucket 	= aws_s3_bucket.this.id

	key 		= each.value
	source 	= "${path.module}/s3_site/${each.value}"

	content_type 	= lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
	etag 					= filemd5("${path.module}/s3_site/${each.value}")
}