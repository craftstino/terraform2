provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "terraformvpc" {

  cidr_block = "192.168.0.0/16"
  
  enable_dns_hostnames = true

  tags = {
    Name = "terraformvpc"
  }
}