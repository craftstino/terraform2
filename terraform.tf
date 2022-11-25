provider "aws" {
  region = "eu-west-1"
}

/*
resource "aws_security_group" "terraformgroup" {
  name        = "terraformgroup"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.terraform.cidr_block]
  }
    ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.terraform.cidr_block]
  }
    ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.terraform.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraformgroup"
  }
}


*/



resource "aws_vpc" "terraformvpc" {

  cidr_block = "192.168.0.0/16"
  
  enable_dns_hostnames = true

  tags = {
    Name = "terraformvpc"
  }
}

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
  
  availability_zone = "eu-west-1b"
  
  tags = {
    Name = "terraformprivate1"
  }
}

resource "aws_internet_gateway" "terraformgateway" {
 
  vpc_id = aws_vpc.terraformvpc.id

  tags = {
    Name = "terraformgateway"
  }
}

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

resource "aws_security_group" "WS-SG" {

  description = "HTTP, PING, SSH"

  name = "webserver-sg"

  vpc_id = aws_vpc.terraformvpc.id

  ingress {
    description = "HTTP for webserver"
    from_port   = 80
    to_port     = 80

    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "MySQL-SG" {

  description = "MySQL Access only from the Webserver Instances!"
  name = "mysql-sg"
  vpc_id = aws_vpc.terraformvpc.id

  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.WS-SG.id]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "BH-SG" {

  description = "MySQL Access only from the Webserver Instances!"
  name = "bastion-host-sg"
  vpc_id = aws_vpc.terraformvpc.id
    ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    description = "output from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "DB-SG-SSH" {

  description = "MySQL Bastion host access for updates!"
  name = "mysql-sg-bastion-host"
  vpc_id = aws_vpc.terraformvpc.id

  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.BH-SG.id]
  }

  egress {
    description = "output from MySQL BH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
resource "aws_instance" "terraformbastionserver" {
  
  ami = "ami-01cae1550c0adea9c"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terraformpublic1.id

  key_name = "stijn2"

  vpc_security_group_ids = [aws_security_group.BH-SG.id]
  tags = {
   Name = "terraformbastionserver"
  }
}
*/

resource "aws_launch_template" "terraformtemp" {
  name = "terraformtemp"
   
  #disable_api_stop        = true
  #disable_api_termination = true
  instance_type = "t2.micro"
  
  image_id = "ami-01cae1550c0adea9c"

  network_interfaces {
    subnet_id = aws_subnet.terraformpublic1.id
    security_groups = [aws_security_group.BH-SG.id]
  }

  key_name = "stijn2"

}

resource "aws_autoscaling_group" "terraformscaling" {
  name = "autoscaling"
  availability_zones = ["eu-west-1a"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
 

  launch_template {
    id      = aws_launch_template.terraformtemp.id
    version = "$Latest"
  }

}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "terraformore80"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terraformscaling.name
  }

  alarm_actions     = [aws_autoscaling_policy.terraformpolicymore.arn]

}

resource "aws_cloudwatch_metric_alarm" "terraformlower" {
  alarm_name                = "terraforlower50"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terraformscaling.name
  }

  alarm_actions     = [aws_autoscaling_policy.terraformpolicylower.arn]
  }

resource "aws_autoscaling_policy" "terraformpolicymore" {
  name = "test2"
  autoscaling_group_name = aws_autoscaling_group.terraformscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = 300
}

resource "aws_autoscaling_policy" "terraformpolicylower" {
  name = "test1"
  autoscaling_group_name = aws_autoscaling_group.terraformscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = 300
}

/*

//nu maken we bucket aan hier 
resource "aws_s3_bucket" "terraformbucket" {
  bucket = "terraformbucketstijnc"

  tags = {
    Name        = "terraformbucketstijnc"
  }
}

resource "aws_s3_bucket_acl" "terraformbucetacl" {
  bucket = aws_s3_bucket.terraformbucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraformversioning" {
  bucket = aws_s3_bucket.terraformbucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "addremove" {
  bucket = "terraformbucketstijnc"
  key    = "addremove.php"
  content = "https://raw.githubusercontent.com/dust555/TM_CloudComputing/master/php/addremove.php"
}


resource "aws_s3_object" "connect" {
  bucket = "terraformbucketstijnc"
  key    = "connect.php"
  content = "https://raw.githubusercontent.com/dust555/TM_CloudComputing/master/php/connect.php"
}

resource "aws_s3_object" "createtable" {
  bucket = "terraformbucketstijnc"
  key    = "createtable.php"
  content = "https://raw.githubusercontent.com/dust555/TM_CloudComputing/master/php/createtable.php"
}

resource "aws_s3_object" "list" {
  bucket = "terraformbucketstijnc"
  key    = "list.php"
  content = "https://raw.githubusercontent.com/dust555/TM_CloudComputing/master/php/list.php"
}

resource "aws_s3_object" "eekhoorn" {
  bucket = "terraformbucketstijnc"
  key    = "eekhoorn"
  content = "https://images.pexels.com/photos/47547/squirrel-animal-cute-rodents-47547.jpeg?cs=srgb&dl=pexels-pixabay-47547.jpg&fm=jpg"
  acl = "public-read"
}

resource "aws_s3_object" "stijnindexhtml" {
  bucket = "terraformbucketstijnc"
  key    = "stijnindex.html"
  source = "https://raw.githubusercontent.com/craftstino/html/main/stijnindex.html"
  acl = "public-read"
}

resource "aws_s3_object" "errorhtml" {
  bucket = "terraformbucketstijnc"
  key    = "error.html"
  source = "https://raw.githubusercontent.com/craftstino/html/main/error.html"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "terraformstaticwebsite" {
  bucket = aws_s3_bucket.terraformbucket.bucket

  index_document {
    suffix = "stijnindex.html"
  }

  error_document {
    key = "error.html"
  }
}

*/