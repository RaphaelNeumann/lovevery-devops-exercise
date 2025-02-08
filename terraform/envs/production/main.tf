module "main" {
  source = "../../."

  application_name      = "devops-exercise"
  application_namespace = "prod-devops-exercise"
  environment           = "production"

}