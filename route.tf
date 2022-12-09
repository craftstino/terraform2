
resource "aws_route_table" "terraformpubroute" {

  vpc_id = aws_vpc.terraformvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraformgateway.id
  }

  tags = {
    Name = "terraformpubroute"
  }
}

resource "aws_route_table_association" "terraformassociation" {

  subnet_id      = aws_subnet.terraformpublic1.id

  route_table_id = aws_route_table.terraformpubroute.id
}


resource "aws_route_table" "terraformprivateroute" {
    vpc_id = aws_vpc.terraformvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "terraformpubroute"
    
  }
}

resource "aws_route_table_association" "terraformassociationpriv1" {

  subnet_id = aws_subnet.terraformprivate1.id

  route_table_id = aws_route_table.terraformprivateroute.id
}

resource "aws_route_table_association" "terraformassociationpriv2" {

  subnet_id = aws_subnet.terraformprivate2.id

  route_table_id = aws_route_table.terraformprivateroute.id
}


