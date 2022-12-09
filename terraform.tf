#######################
# not a imported file #
#######################


/*


provider "aws" {
  region = "eu-west-1"
}

//
//
//networking
//
//


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


resource "aws_route_table" "terraformprivateroute" {
    vpc_id = aws_vpc.terraformvpc.id

  #route {
  #  cidr_block = "0.0.0.0/0"
  # gateway_id = aws_internet_gateway.terraformgateway.id
  #}

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









//
//
//security groups 
//
//




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

    ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "HTTP for webserver"
    from_port   = 80
    to_port     = 80

    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.WS-SG.id]
  }
  

  egress {
    description = "output from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




//
//
//buckets
//
//




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
  source = "web-servers/addremove.php"
  acl = "public-read"
}


resource "aws_s3_object" "connect" {
  bucket = "terraformbucketstijnc"
  key    = "connect.php"
  source = "web-servers/connect.php"
  acl = "public-read"
}

resource "aws_s3_object" "createtable" {
  bucket = "terraformbucketstijnc"
  key    = "createtable.php"
  source = "web-servers/createtable.php"
  acl = "public-read"
}

resource "aws_s3_object" "list" {
  bucket = "terraformbucketstijnc"
  key    = "list.php"
  source = "web-servers/list.php"
  acl = "public-read"
}

resource "aws_s3_object" "eekhoorn" {
  bucket = "terraformbucketstijnc"
  key    = "eekhoorn"
  source = "web-servers/eekhoorn.jpg"
  acl = "public-read"
}

resource "aws_s3_object" "indexhtml" {
  bucket = "terraformbucketstijnc"
  key    = "index.html"
  source = "web-servers/index.html"
  acl = "public-read"
}

resource "aws_s3_object" "errorhtml" {
  bucket = "terraformbucketstijnc"
  key    = "error.html"
  source = "web-servers/error.html"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "terraformstaticwebsite" {
  bucket = aws_s3_bucket.terraformbucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}




//
//
//instances
//
//



resource "aws_instance" "terraformbastionserver" {
  
  ami = "ami-096800910c1b781ba"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terraformpublic1.id
  availability_zone = "eu-west-1a"

  key_name = "stijn2"

  vpc_security_group_ids = [aws_security_group.BH-SG.id]
  tags = {
   Name = "terraformbastionserver"
  }

  user_data = <<EOF
#!/bin/bash
apt-get update -y
apt install apache2 -y
apt install awscli -y
apt install php8.1 -y
touch /var/www/html/info.html 
curl http://checkip.amazonaws.com >> /var/www/html/info.html
echo " " >> /var/www/html/info.html
hostname >> /var/www/html/info.html
cd /var/www/html
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/connect.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/addremove.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/createtable.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/list.php
sudo mv index.html.1 index.html
EOF
}

/*
resource "aws_launch_template" "terraformtemp" {
  name = "terraformtemp"
   
  #disable_api_stop        = true
  #disable_api_termination = true
  instance_type = "t2.micro"
  
  image_id = "ami-096800910c1b781ba"

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

*/





#nu maken we database 
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