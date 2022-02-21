provider "aws" {
  region     = "us-east-2"
 }
resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg"
  ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "all"
   cidr_blocks = ["0.0.0.0/0"]
  }
tags ={
    type ="terraform-test-security-group"
  }
}

resource "aws_instance" "dockerserver" {
  ami = "ami-0b614a5d911900a9b"
  instance_type = "t2.micro"
  key_name= "aws_key"
  security_groups = [aws_security_group.ec2-sg.name]
  tags = {
    Name = "dockerserver"
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "jenkins"
      private_key = file("/home/jenkins/keys/aws_key")
      timeout     = "4m"
   }
}
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmVSX260JUmiJevmGUzMESKv5FGdOXZjyWfqodIK0MEOvJUFLQZKD/ephylDWVpGP1BFK/FOfUR0wYKSXoBdIzaJABP1Zl9/f48Ke5j9pFDcPMORj3ocs2STmoFAIPxnF/ZFgmfEzSlZaRjz58aSKOirAFePgmTXlFoEfTX+LWSGym5QseEc7+CSzDaBJay1LpmhJ+bLsyIwYHKmspJuaKSvgzLdsKOs1adWk3DKN4yqYEJLV+KzUTH+NctuF180JnozNADwe5OvwvOFBr0p1tXVAqKEzvGXrKHCMdRyutcwn/VSR19dM6etNCajbRdHp+iihNAAvQKfAJzr3Gxq/t jenkins@ip-172-31-15-167.us-east-2.compute.internal"
}
