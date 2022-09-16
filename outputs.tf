output "congito_pool_arn" {
  description = "The ARN of the cognito user pool"
  value       = aws_cognito_user_pool.main.arn
}

output "client_id" {
  description = "Client ID of the react native client created for interfacing with the user pool."
  value       = aws_cognito_user_pool_client.main.id
}