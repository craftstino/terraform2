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
sudo apt-get install php-mysql -y
apt install apache2 -y
apt install awscli -y
apt install php8.1 -y
touch /var/www/html/info.html 
curl http://checkip.amazonaws.com >> /var/www/html/info.html
echo " " >> /var/www/html/info.html
hostname >> /var/www/html/info.html
sudo apt install putty -y
touch /home/ubuntu/key
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAnlgsL289Pl4O/aAOEaIcS+nNT9BsgSM2ECrDx4r+TK37YMdu
EHoEge+0nruowQ4OCVPsGFjS131eCZdhO0vJUK7mtBL/VRvMm0qgqdtoNMv1TJYp
pS9pb1+JGYZ0Z3vFrCqi3TFN7btlq6fg3himoY3ETDsYgdK0lldK7IHneQNW+J5C
KRYj6Tv+1QelnxKgkzWmNJk3JnUuX+l9bPzMRFjs87KvkuG0iGjXVixz6TFW2EVP
1yxzjP1o7bgMIq4sOt+n6ZwerqCJ4/aiZJmbl9VtWBf9zv3YdFR0kmjLGYaMKtcR
aOtifliJ617pqUMeUmG8ptFCXbdMokqdjq072QIDAQABAoIBAQCKgD1F0FsVblhW
Z+VmbxGpJPw8z+XYnt/vDDjrFRySHaw/XrFbIB9JOE4YebSGCLEmX42nTio96p6S
bSLTJtsUA6gv4l4MJ6C0RHZ7nDpt0+jf8IjEv8/NZxcYiI7Q5WZlzXVfXHz5cGzh
1JnQKme177a/pwEsrQzgY8JZVNcO9QbAgV3yEFJLFPOPJ0Mqnu+P64x74FLPithT
t9+QogRKt1P/cirEF6ftuyVy7tqAvozeBLTGPhqRd1fan7IFZZxGN0AMVU7mnCdC
Q+OhNRMN7c4Wa/lJfhRn0DNi5FcHN63aJr4MgTyyNfadUnfEp3fX0mcPfgkEKlkh
flW5Yk/xAoGBAN9zyHMgsvZ7Dvf+ikpIJpzHNR13lIDw3G+2cVo+RmjI4RD78IlZ
6SRVIdAmw/xr5DLnPl2zrmJKvLR5pE8wD3nzF17NtxelSuhFwNx5eLMOSeMXPAl5
zEPDGZFszcy2oIAWvgYOHCvk5VB02mUiSUbSHCU2nHjZ+S8Ud7L+9OI3AoGBALVo
nEurBfb8SErTTCIB770QIw/uUVVoiR1qbbVbL2iozqCdALb+vk+L622od4BVaF/1
vGzdXajd/rYx/BD0TPtcOF4+QflaffVeWjAlpVQPtomAiG01Kt+jePdRlhcuwt6S
g6buIcErBlNeN/ff/hdP7Gwuv/nusYip2pnbHwpvAoGBALcJ7QUBoBdvrk9O3pEC
kT6Tn9rHfYoxwyBvXmMB6EMladezyNF6KRRt+Ai9+ITpDED2U4wGB67UcceUbRfA
0qyeiGJMONLRv46MtPLlPg3Ogo/XFILelohbZLJPYjVy0/6YoofrPwBlu8IwNkXp
1ASDUDLbjUkhpJEAPx0M5CP5AoGBAImqV2G86YvjK+FMtCvimFI7msAONL7B07v0
9kh4aGPeJuAQBWjZrQakwga3n+hN6CVaUKG048ywmwkcqZMcMgdWlpg+Wsal+4xn
C74Z83r1aaqzVdS6Ukzgu33D9kilfdB2E15svEThJ63AhGyhGSwLxPjcCWfb0fJK
I9A6TzYVAoGAMoG4odCSXZUjEn2mkX97vOJDGTafjb/d7qmXo6wLI9+cgoSov2+W
fDSwLUw1SN/F/4qefPAZl/WdEdToy0o7AbFfpYlGYl146AQhaDZRQmvxhjhhZ+yC
FNTJWwYaeKNeiLT8ybqcZLRzkheRKM/PpGSGZf++lrWfdG6BEQmNiDE=
-----END RSA PRIVATE KEY-----" >> /home/ubuntu/key
cd /var/www/html
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/connect.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/addremove.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/createtable.php
sudo wget https://terraformbucketstijnc.s3.eu-west-1.amazonaws.com/list.php
EOF
}




resource "aws_instance" "terraformprivatevm" {
  
  ami = "ami-096800910c1b781ba"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.terraformprivate1.id
  availability_zone = "eu-west-1a"

  key_name = "pemfile"

  vpc_security_group_ids = [aws_security_group.priv.id]
  tags = {
   Name = "terraformprivatevm"
  }
}