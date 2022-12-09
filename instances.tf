

resource "aws_instance" "terraformbastionserver" {
  
  ami = "ami-096800910c1b781ba"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terraformpublic1.id
  availability_zone = "eu-west-1a"

  key_name = "TF_key"

  vpc_security_group_ids = [aws_security_group.BH-SG.id]
  tags = {
   Name = "terraformbastionserver"
  }

  depends_on = [
    aws_key_pair.TF_key,tls_private_key.rsa,local_file.TF-key
  ]

  user_data = <<EOF
#!/bin/bash
apt-get update -y
sudo apt-get install php-mysql -y
apt install apache2 -y
apt install awscli -y
apt install php8.1 -y
touch /var/www/html/info.html 
curl http://checkip.amazonaws.com >> /var/www/html/info.html
echo " " >> /var/www/html/info.html
hostname >> /var/www/html/info.html
echo " " >> /var/www/html/info.html
echo "<div class="col"><img src="https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/eekhoorn" width="100"></div>" >> /var/www/html/info.html
sudo apt install putty -y
cd /var/www/html
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/connect.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/addremove.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/createtable.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/list.php
cd /home/ubuntu
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/TF_key
EOF
}




resource "aws_instance" "terraformprivatevm" {
  
  ami = "ami-096800910c1b781ba"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terraformprivate1.id
  availability_zone = "eu-west-1a"

  key_name = "TF_key" 

  vpc_security_group_ids = [aws_security_group.priv.id]
  tags = {
   Name = "terraformprivatevm"
  }

  depends_on = [
    aws_key_pair.TF_key,tls_private_key.rsa,local_file.TF-key
  ]
}
