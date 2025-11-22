resource "aws_apigatewayv2_api" "this" {
  name                       = "live-viewer-count"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "connect" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_apigatewayv2_integration" "connect" {
  description               = "Integration for $connect route"
  api_id                    = aws_apigatewayv2_api.this.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.viewer_count_onconnect.invoke_arn
  integration_method        = "POST"
  content_handling_strategy = "CONVERT_TO_TEXT"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_integration" "disconnect" {
  description               = "Integration for $disconnect route"
  api_id                    = aws_apigatewayv2_api.this.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.viewer_count_ondisconnect.invoke_arn
  integration_method        = "POST"
  content_handling_strategy = "CONVERT_TO_TEXT"
}

resource "aws_apigatewayv2_stage" "dev_stage" {
  name = "dev"

  api_id        = aws_apigatewayv2_api.this.id
  deployment_id = aws_apigatewayv2_deployment.this.id
}

resource "aws_apigatewayv2_deployment" "this" {
  depends_on = [
    aws_apigatewayv2_integration.connect,
    aws_apigatewayv2_route.connect,
    aws_apigatewayv2_integration.disconnect,
    aws_apigatewayv2_route.disconnect
  ]

  api_id      = aws_apigatewayv2_api.this.id
  description = "Deployment for live viewer count API"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.connect),
      jsonencode(aws_apigatewayv2_route.connect),
      jsonencode(aws_apigatewayv2_integration.disconnect),
      jsonencode(aws_apigatewayv2_route.disconnect)
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.viewer_count_onconnect.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*"
}

output "api" {
  value = {
    endpoint = split("://", aws_apigatewayv2_api.this.api_endpoint)[1]
    name     = aws_apigatewayv2_stage.dev_stage.name
  }
}
