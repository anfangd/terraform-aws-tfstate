output "dynamodb" {
  description = "output of dynamodb"
  value = {
    arn          = aws_dynamodb_table.this.arn
    id           = aws_dynamodb_table.this.id
    replica      = aws_dynamodb_table.this.replica
    stream_arn   = aws_dynamodb_table.this.stream_arn
    stream_label = aws_dynamodb_table.this.stream_label
    tags_all     = aws_dynamodb_table.this.tags_all
  }
}
