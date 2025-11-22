locals {
  function_names = {
    update_viewer_count       = aws_iam_policy.update_viewer_count_policy.arn
    viewer_count_onconnect    = aws_iam_policy.viewer_count_onconnect_policy.arn
    viewer_count_ondisconnect = aws_iam_policy.viewer_count_ondisconnect_policy.arn
  }
}

data "archive_file" "lambda" {
  for_each = local.function_names

  type        = "zip"
  source_file = "${path.module}/lambda/${each.key}.py"
  output_path = "${path.module}/lambda/${each.key}-func.zip"
}

resource "aws_lambda_function" "update_viewer_count" {
  function_name    = "update_viewer_count"
  role             = aws_iam_role.lambda_exec["update_viewer_count"].arn
  handler          = "update_viewer_count.lambda_handler"
  runtime          = "python3.13"
  filename         = data.archive_file.lambda["update_viewer_count"].output_path
  source_code_hash = data.archive_file.lambda["update_viewer_count"].output_base64sha256
  timeout          = 29

  environment {
    variables = {
      API_INVOKE_URL = replace(aws_apigatewayv2_stage.dev_stage.invoke_url, "wss", "https")
    }
  }
}

resource "aws_lambda_function" "viewer_count_onconnect" {
  function_name    = "viewer_count_onconnect"
  role             = aws_iam_role.lambda_exec["viewer_count_onconnect"].arn
  handler          = "viewer_count_onconnect.lambda_handler"
  runtime          = "python3.13"
  filename         = data.archive_file.lambda["viewer_count_onconnect"].output_path
  source_code_hash = data.archive_file.lambda["viewer_count_onconnect"].output_base64sha256
  timeout          = 29
}

resource "aws_lambda_function" "viewer_count_ondisconnect" {
  function_name    = "viewer_count_ondisconnect"
  role             = aws_iam_role.lambda_exec["viewer_count_ondisconnect"].arn
  handler          = "viewer_count_ondisconnect.lambda_handler"
  runtime          = "python3.13"
  filename         = data.archive_file.lambda["viewer_count_ondisconnect"].output_path
  source_code_hash = data.archive_file.lambda["viewer_count_ondisconnect"].output_base64sha256
  timeout          = 29
}

####################################################################
#    IAM policies for Lambda functions to access DynamoDB tables   #
# Do not edit below unless something is wrong/you added a function #
####################################################################

resource "aws_iam_role" "lambda_exec" {
  for_each = local.function_names

  name = "lambda_exec_role-${each.key}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "update_viewer_count_policy" {
  name        = "ViewerCountDBAccess"
  description = "IAM policy for Lambda functions to access DynamoDB viewer count table"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Query",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.viewer_count_db.arn
      },
      {
        Action = [
          "dynamodb:Scan",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.connection_id_db.arn
      },
      {
        Action = [
          "execute-api:ManageConnections"
        ]
        Effect   = "Allow"
        Resource = "${aws_apigatewayv2_api.this.execution_arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "viewer_count_onconnect_policy" {
  name        = "ViewerCountOnConnectPolicy"
  description = "IAM policy for $connect Lambda function"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.connection_id_db.arn
      }
    ]
  })
}

resource "aws_iam_policy" "viewer_count_ondisconnect_policy" {
  name        = "ViewerCountOnDisconnectPolicy"
  description = "IAM policy for $disconnect Lambda function"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.connection_id_db.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basicexec_attachments" {
  for_each = local.function_names

  role       = aws_iam_role.lambda_exec[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachments" {
  for_each = local.function_names

  role       = aws_iam_role.lambda_exec[each.key].name
  policy_arn = each.value
}
