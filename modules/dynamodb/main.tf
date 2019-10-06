resource "aws_dynamodb_table" "table" {
  name           = "${var.table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "${var.hash_key}"
  
  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

output "table_arn" {
  value = aws_dynamodb_table.table.arn
}