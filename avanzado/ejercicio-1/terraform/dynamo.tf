resource "aws_dynamodb_table" "employee_table" {
    name = "Employee"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "Id"
    attribute {
      name = "Id"
      type = "S"
    }
    # attribute {
    #   name = "startDate"
    #   type = "S"
    # }
  
}