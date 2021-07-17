data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "growi" {
  name               = "${local.prefix}-server"
  assume_role_policy = file("./ec2-instance/instance-profile-policy.json")

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "growi" {
  name = "${local.prefix}-growi-instance-profile"
  role = aws_iam_role.growi.name
}

resource "aws_instance" "growi" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./ec2-instance/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.growi.name
  # key_name             = var.access_key_name
  subnet_id  = aws_subnet.public.id
  private_ip = "${local.vpc_cidr_network}.1.10"

  vpc_security_group_ids = [
    aws_security_group.growi.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-server"
    },
  )
}

resource "aws_eip" "growi" {
  vpc = true

  instance                  = aws_instance.growi.id
  associate_with_private_ip = "${local.vpc_cidr_network}.1.10"
  depends_on                = [aws_internet_gateway.main]
}

resource "aws_security_group" "growi" {
  description = "Control server inbound and outbound access"
  name        = "${local.prefix}-server"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
