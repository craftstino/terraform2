
resource "aws_internet_gateway" "terraformgateway" {
 
  vpc_id = aws_vpc.terraformvpc.id

  tags = {
    Name = "terraformgateway"
  }
}
