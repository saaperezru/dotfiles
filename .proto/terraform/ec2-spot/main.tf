# Provisions a spot EC2 instance with Centos 7.4 image
# Zone for AMI is us-east-1

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "test-env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet-uno" {
  # creates a subnet
  cidr_block        = "${cidrsubnet(aws_vpc.test-env.cidr_block, 3, 1)}"
  vpc_id            = "${aws_vpc.test-env.id}"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "ingress-ssh-test" {
  name   = "allow-ssh-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ingress-mysql" {
  name   = "allow-mysql-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]

    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

resource "aws_security_group" "ingress-elastic-2" {
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]

    from_port = 9300
    to_port   = 9300
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-elastic-1" {
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 9200
    to_port   = 9200
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_spot_instance_request.test_worker.spot_instance_id}"
  vpc      = true
}

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.test-env.id}"
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.test-env.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}

resource "aws_key_pair" "spot_key" {
  key_name   = "spot_key"
  public_key = "${file("/home/santi/.ssh/id_rsa.pub")}"
}

data "aws_key_pair" "Santi_Kinesso" {
  key_pair_id = "key-05670de3838abadf0"
}

resource "aws_spot_instance_request" "test_worker" {
  ami                    = "ami-04505e74c0741db8d"
  spot_price             = "0.0125"
  instance_type          = "t3.medium"
  #spot_price             = "0.04"
  #instance_type          = "m6i.large"
  spot_type              = "one-time"
  wait_for_fulfillment   = "true"
  key_name               = "Santi_Kinesso"

  root_block_device {
    volume_size = 100
  }

  lifecycle {
    ignore_changes = [security_groups]
  }

  security_groups = ["${aws_security_group.ingress-ssh-test.id}", "${aws_security_group.ingress-mysql.id}","${aws_security_group.ingress-elastic-1.id}","${aws_security_group.ingress-elastic-2.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"
}

output "instance_ip_addr" {
    value = aws_spot_instance_request.test_worker.public_dns
}
