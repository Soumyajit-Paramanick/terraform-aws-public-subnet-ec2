terraform {
  backend "s3" {
    bucket         = "terraform-practice-bucket-03-04-2026"
    key            = "dev/terraform.tfstate"
    region        = "us-east-1"
  }
}