resource "aws_api_gateway_rest_api" "mail_api" {
  name        = var.api_name
  description = "This API is for trigger lamnda"
}

resource "aws_api_gateway_resource" "mail_api_resource" 
  rest_api_id = aws_api_gateway_rest_api.mail_api.id
  parent_id   = aws_api_gateway_rest_api.mail_api.root_resource_id
  path_part   = mail
}

resource "aws_api_gateway_method" "mail_method" {
  rest_api_id   = aws_api_gateway_rest_api.mail_api.id
  resource_id   = aws_api_gateway_resource.mail_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_stage" "mail_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.mail_api.id
  deployment_id = aws_api_gateway_deployment.mail_deployment.id
}
resource "aws_api_gateway_deployment" "mail_deployment" {
  depends_on  = ["aws_api_gateway_integration.test"]
  rest_api_id   = aws_api_gateway_rest_api.mail_api.id
  stage_name  = "prod"
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id   = aws_api_gateway_rest_api.mail_api.id
  resource_id   = aws_api_gateway_resource.mail_api_resource.id
  http_method             = aws_api_gateway_method.mail_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.mail_lambda.invoke_arn
}