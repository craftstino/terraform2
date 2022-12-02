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
