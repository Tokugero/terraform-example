# This file is responsible for creating the baseline compute necessary to serve something worth viewing.

locals {
  ec2_count = 12 # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# SSH Key
resource "aws_key_pair" "example" {
  key_name   = "example"
  public_key = file("../.env/sshkey.pub")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# EC2 AMI lookup
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Security Group
resource "aws_security_group" "example_http" {
  name   = "terraform-example-http"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Security Group
resource "aws_security_group" "example_ssh" {
  name   = "terraform-example-ssh"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Security Group
resource "aws_security_group" "example_outbound" {
  name   = "terraform-example-outbound"
  vpc_id = module.vpc.vpc_id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  count = local.ec2_count

  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = true
  instance_type               = "t3.nano"
  security_groups             = [aws_security_group.example_http.id, aws_security_group.example_ssh.id, aws_security_group.example_outbound.id]
  subnet_id                   = element(module.vpc.public_subnets, count.index)

  key_name                    = "example"
  user_data_replace_on_change = true
  user_data                   = file("./userdata.sh")
}

resource "aws_lb_target_group" "http" {
  name        = "http"
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_alb_target_group_attachment" "http" {
  count = local.ec2_count

  target_group_arn = aws_lb_target_group.http.id
  target_id        = element(aws_instance.example.*.id, count.index)
}

resource "aws_lb" "http" {
  name               = "terraform-example"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example_http.id, aws_security_group.example_outbound.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.http.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
