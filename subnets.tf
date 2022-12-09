
resource "aws_subnet" "terraformpublic1" {
  
  vpc_id = aws_vpc.terraformvpc.id
  
  cidr_block = "192.168.0.0/24"
  
  availability_zone = "eu-west-1a"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformpublic1"
  }
}

resource "aws_subnet" "terraformprivate1" {

  vpc_id = aws_vpc.terraformvpc.id
  
  cidr_block = "192.168.1.0/24"
  
  availability_zone = "eu-west-1a"
  
  tags = {
    Name = "terraformprivate1"
  }
}

resource "aws_subnet" "terraformprivate2" {

  vpc_id = aws_vpc.terraformvpc.id
  
  cidr_block = "192.168.2.0/24"
  
  availability_zone = "eu-west-1b"
  
  tags = {
    Name = "terraformprivate2"
  }
}

#done