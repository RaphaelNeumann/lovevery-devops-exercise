locals {
    service_env_vars = [
                       for key in keys(jsondecode(data.aws_secretsmanager_secret_version.env.secret_string)):
                         {
                           name      = key
                           valueFrom = format("%s:%s::", aws_secretsmanager_secret.env.arn, key)
                         }
                     ]
}