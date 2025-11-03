resource "aws_pipes_pipe" "this" {
	name 				= "UpdateViewerCountOnNewConnectionPipe"
	description = "Trigger update-viewer-count Lambda on new connection ID inserts"
	role_arn 		= aws_iam_role.pipe_exec.arn
	source 			= aws_dynamodb_table.connection_id_db.stream_arn
	target 			= aws_lambda_function.update_viewer_count.arn

	source_parameters {
		
		dynamodb_stream_parameters {
			starting_position = "LATEST"
		}

		filter_criteria {
			filter {
				pattern = jsonencode({
					eventName = ["INSERT"]
				})
			}
		}
	}
}

resource "aws_iam_role" "pipe_exec" {
	name 								= "PipeExecutionRole"
  assume_role_policy 	= jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "pipes.amazonaws.com"
      }
    }
  })
}

resource "aws_iam_role_policy" "db_pipe_policy" {
	role 		= aws_iam_role.pipe_exec.name
	policy 	= jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Action = [
						"dynamodb:DescribeStream",
						"dynamodb:GetRecords",
						"dynamodb:GetShardIterator",
						"dynamodb:ListStreams"
				]
				Effect   = "Allow"
				Resource = aws_dynamodb_table.connection_id_db.stream_arn
			}
		]
	})
}

resource "aws_iam_role_policy" "lambda_pipe_policy" {
	role 		= aws_iam_role.pipe_exec.name
	policy 	= jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Action = [
						"lambda:InvokeFunction"
				]
				Effect   = "Allow"
				Resource = aws_lambda_function.update_viewer_count.arn
			}
		]
	})
}