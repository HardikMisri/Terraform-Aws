# Region

# provider "aws" {

#   region = "us-west-2"

# }

# Key Value pair

resource "aws_key_pair" "my_key_pair" {

  key_name   = "terra-automate-key-josh"
  public_key = file("terra-automate-key.pub")
}

# VPC Default

resource "aws_default_vpc" "default" {
}

# Security Group 

resource "aws_security_group" "my_security_group" {

  name        = "terra-security-group"
  vpc_id      = aws_default_vpc.default.id # interpolation
  description = "this is Inbound and outbound rules for your instance Security group"

}

# Inbound & Outbount port rules



resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# EC2 instance


resource "aws_instance" "my_instance" {

  count = 3
  ami   = "ami-0d76b909de1a0595d" # OS AMI ID

  instance_type = "t3.micro" # Instance Type

  key_name = aws_key_pair.my_key_pair.key_name # Key pair

  vpc_security_group_ids = [aws_security_group.my_security_group.id] # VPC & Security Group

  # root storage (EBS)
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "terra-automate-server"
  }
}

#To create multiple Instances 

#metaargument can be used : Count 
#resource "aws_instance" "web" {
#  count = 2. IT creates multiple instance in terraform 
#}

#Make sure to change Output.tf as there are multiple instance 
# then we might need multiple public ip 
# for that we can use [*]
# aws_instance.my_instances[*].public_ip
# this wil create multiple instance with same name

#Instance type :  Spot/ On demand 
#Spot : Based on Bidding - less cost
#On Demand : Prices are fixed and all the instances will be availiable 

#Use for-each for multiple instance 

#for_each = tomap({
#key = value
#key = value 
#})

#Example 

#for_each = tomap({
#"TWS-junnon-automate-micro" =  "t2.micro",
#"Tws-junnon-auomate-medium" = "t2.medium "

#})

#instance_type = each.value
#intance_name = each.key

#How to map for_each output 
# output "Ec2_public_ip" {
#. value = [for intance in aws_instance.my_instance : instance.public_ip
#.     ] 
#. }
#
#


#meta-argument : depends_on : To create dependency in resource creation 


##Conditional 
#. if env = prod : vol = 20gib
#else env = dev : vol = 10gib


# variable "env"{

# }

#var.env == "prod" ? 20 : var.ec2_default_storage
