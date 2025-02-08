resource "aws_secretsmanager_secret" "env" {
  name = "${var.application_name}-${var.environment}/env"
}

data "aws_secretsmanager_secret_version" "env" {
  secret_id = aws_secretsmanager_secret.env.id
}