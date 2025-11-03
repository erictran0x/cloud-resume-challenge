resource "aws_dynamodb_table" "viewer_count_db" {
	name 					= "viewer-count"
	billing_mode 	= "PAY_PER_REQUEST"
	hash_key 			= "id"

	attribute {
		name = "id"
		type = "S"
	}
}

resource "aws_dynamodb_table" "connection_id_db" {
	name 							= "viewer-count-connection-ids"
	billing_mode 			= "PAY_PER_REQUEST"
	hash_key 					= "id"
	stream_enabled 		= true
	stream_view_type 	= "NEW_IMAGE"

	attribute {
		name = "id"
		type = "S"
	}
}