resource "aws_api_gateway_rest_api" "api" {
    name = "Employee_formador"
    description = "api del ejercicio1, empleados"
  
}

resource "aws_api_gateway_resource" "resource_employees" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id   
    path_part = "employees"
}


resource "aws_api_gateway_method" "method" {
    resource_id = aws_api_gateway_resource.resource_employees.id
    rest_api_id = aws_api_gateway_rest_api.api.id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.resource_employees.id
    http_method = aws_api_gateway_method.method.http_method
    type = "AWS_PROXY"
    integration_http_method = "GET"
    uri = aws_lambda_function.lambda_function_1.invoke_arn
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on = [ aws_api_gateway_integration.integration ]
  stage_name = "CURSO"
}


output "domain" {
    value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "api_employess_endpoint" {
    value = "${aws_api_gateway_deployment.deployment.invoke_url}/${aws_api_gateway_resource.resource_employees.path_part}"
}