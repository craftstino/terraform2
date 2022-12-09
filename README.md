# terraform Stijn Ceulemans

I create 1 VPC with 1 public and 2 private subnets. 

The public subnets has a internet-gatway in his router to acces the internet.

The private subnet has a NAT-gateway in his router to have access to the internet.

Also created a S3 bucket with versioning enabled that is also a static website with muliple file uploaded to the bucket.

Create 2 EC2 instance 1 in the private subnet and the other one in the public.
The one called teraformbastionserver is the public one and can be entered using ssh with the key that is made in teraform is uploaded to the map where the terraformfiles where executed and aslo in the bucket (just to make sure).
This key is also downloaded from the bucket bye the public machine and located in the home directory and can be used to ssh to the private EC2 instance. This can be done bye using the command ssh -i TF_key ubuntu@[ip of the private EC2 instance].
The public EC2 instance also has a apache2 webserver running white a info.html file where we can see the private and public ip of the instance and also a picture that was stored in the bucket.

There is also a autoscaling group running with a standart of 2 EC2 instances when there is not mutch cpu usage they will scale down to 1 EC2 and if there is alot cpu usage they will scale up to a max of 3 EC2 instances.

there is also a database created.

