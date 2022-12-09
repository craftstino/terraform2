

resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.terraformpublic1.id
}

#done