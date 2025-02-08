terraform {
  backend "s3" {
    bucket = "terraform-state.lovevery.com"
    key    = "app/devops-exercise/develop"
    region = "us-east-1"
  }
}