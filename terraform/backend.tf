terraform {
  backend "s3" {
    bucket = "travelmemory-terraform-state-rchirutkar-ap-south-1"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}