/*

resource "aws_db_instance" "terraformrds" {
  identifier = "terraformdatabase"
  allocated_storage    = 10
  db_name              = "CloudComputing"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  username             = "stijn"
  password             = "stijn123!"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.terraformrdssubnet.id
}

resource "aws_db_subnet_group" "terraformrdssubnet" {
  name = "terraformrdssubnet"
  subnet_ids = [aws_subnet.terraformprivate2.id,aws_subnet.terraformprivate1.id]
}
*/