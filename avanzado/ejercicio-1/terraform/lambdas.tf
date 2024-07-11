locals {
  jar_file = "../target/LambdaCronFunctions-1.0-SNAPSHOT.jar"
  zip_file = "../target/LambdaCronFunctions-1.0-SNAPSHOT.zip"
}

# resource "null_resource" "zip_lambda" {
#   provisioner "local-exec" {
#     command = "zip -j ${local.zip_file} ${local.jar_file}"
#   }

#     # triggers = {
#     #     jar_file = sha256(file(local.jar_file))
#     # } 
# }

resource "aws_lambda_function" "lambda_function_1" {
    function_name = "cron_formador"
    role = aws_iam_role.lambda_support_role.arn
    runtime = "java11"
    handler = "com.aws.example.Handler::handleRequest"
    package_type = "Zip"
    filename = local.zip_file
    # source_code_hash = filebase64sha256(local.zip_file)
}