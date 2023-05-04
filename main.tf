

provider "aws"{

region = "us-east-2"
access_key = "AKSEIAVQ2ZXDSORRXH"

secret_key = "jm+n3HBOw8suXWQRUSMaP/jApaLSx45GQMyM8IQ"
}



resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}



resource "aws_instance" "example" {

ami = "ami-0aa2b7722dc1b5612"
instance_type = "t2.micro"
key_name = "tf-key-pair"
tags = {
"Name" = "wordpress-instance"
}

}


resource "aws_s3_bucket" "example2" {
  bucket = "my-tt23-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "myrdsuser"
  password             = "myrdspassword"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible =  true
}


