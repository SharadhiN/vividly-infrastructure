terraform {
  backend "gcs" {
    bucket = "vividly-tfstate-staging"
    prefix = "terraform/state"
  }
}