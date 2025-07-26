data "aws_secretsmanager_random_password" "password" {
  password_length = 12
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret" "rds_secrets" {
  name = "${var.prefix}-${var.env_name}-rds-scrts"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.rds_secrets.id
  secret_string = jsonencode({
          username = var.db_username
          password = data.aws_secretsmanager_random_password.password.random_password
      }
    )
}