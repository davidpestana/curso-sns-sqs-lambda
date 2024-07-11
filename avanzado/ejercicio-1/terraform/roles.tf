provider "aws" {
}

# Create the IAM Role for Lambda
resource "aws_iam_role" "lambda_support_role" {
  name = "lambda-support"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWSLambdaBasicExecutionRole policy
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_support_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach AmazonDynamoDBFullAccess policy
resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.lambda_support_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Attach AmazonSNSFullAccess policy
resource "aws_iam_role_policy_attachment" "sns_access" {
  role       = aws_iam_role.lambda_support_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

output "lambda_support_role_arn" {
  value = aws_iam_role.lambda_support_role.arn
}
