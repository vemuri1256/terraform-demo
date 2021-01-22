variable "region" {
  default = ""
}






provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "devl-bma-2213-state-us-east-1"
    key            = "global/workspace_dev/terraform-dev.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dd-table-dev-BMA-lock"
    encrypt        = true
  }
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}