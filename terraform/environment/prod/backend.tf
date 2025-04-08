terraform {
  backend "s3" {
    bucket  = "statefile-bucket" # Name of the S3 bucket for storing Terraform state
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
    // dynamodb_table = "terraform-locks"  
  }
}
