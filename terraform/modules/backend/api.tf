resource "aws_apigatewayv2_api" "this" {
	name 												= "live-viewer-count"
	protocol_type 							= "WEBSOCKET"
	route_selection_expression 	= "$request.body.action"
}

resource "aws_apigatewayv2_route" "connect" {
	api_id 		= aws_apigatewayv2_api.this.id
	route_key = "$connect"
	target 		= "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_apigatewayv2_integration" "connect" {
	description 							= "Integration for $connect route"
	api_id 										= aws_apigatewayv2_api.this.id
	integration_type 					= "AWS_PROXY"
	integration_uri 					= aws_lambda_function.functions["viewer_count_onconnect"].invoke_arn
	integration_method 				= "POST"
	content_handling_strategy = "CONVERT_TO_TEXT"
}

resource "aws_apigatewayv2_route" "disconnect" {
	api_id 		= aws_apigatewayv2_api.this.id
	route_key = "$disconnect"
	target 		= "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_integration" "disconnect" {
	description 							= "Integration for $disconnect route"
	api_id 										= aws_apigatewayv2_api.this.id
	integration_type 					= "AWS_PROXY"
	integration_uri 					= aws_lambda_function.functions["viewer_count_ondisconnect"].invoke_arn
	integration_method 				= "POST"
	content_handling_strategy = "CONVERT_TO_TEXT"
}

resource "aws_apigatewayv2_stage" "dev_stage" {
	api_id 	= aws_apigatewayv2_api.this.id
	name 		= "dev"
}

resource "aws_lambda_permission" "apigw_invoke" {
	statement_id  = "AllowAPIGatewayInvoke"
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.functions["viewer_count_onconnect"].function_name
	principal     = "apigateway.amazonaws.com"
	source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*"
}

output "api" {
	value = {
		invoke_url = aws_apigatewayv2_stage.dev_stage.invoke_url
		name = aws_apigatewayv2_stage.dev_stage.name
	}
}