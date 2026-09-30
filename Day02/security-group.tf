resource "aws_security_group" "ec2" {
  name        = "terraform-ec2-sg"
  description = "Security group for terraform ec2"
  vpc_id      = aws_vpc.main.id
}
