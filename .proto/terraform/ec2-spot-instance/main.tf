# Provisions a spot EC2 instance with ArchLinux EC2 
# Using Uplink Labs generated AMIs https://wiki.archlinux.org/title/Arch_Linux_AMIs_for_Amazon_Web_Services
# Zone for AMI is us-east-1

provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
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

#resource "aws_cloudfront_distribution" "cdn_distribution" {
#    origin {
#        domain_name                   = aws_spot_instance_request.test_worker.public_dns
#        origin_id                     = "${local.origin_id}"
#        custom_origin_config {
#            http_port                 = 80
#            https_port                = 80
#            origin_protocol_policy    = "http-only"
#            origin_ssl_protocols      = ["TLSv1"]
#        }
#    }
#
#    enabled                           = true
#
#    default_cache_behavior {
#        # allowed_methods         = ["HEAD", "GET", "OPTIONS", "PATCH", "POST", "PUT"]
#        allowed_methods               = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#        cached_methods                = ["HEAD", "GET"]
#        target_origin_id              = "${local.origin_id}"
#
#    forwarded_values {
#        query_string                  = true
#        headers                       = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
#        cookies {
#            forward                   = "none"
#        }
#    }
#
#    viewer_protocol_policy            = "redirect-to-https"
#        min_ttl                       = 0
#        default_ttl                   = 3600
#        max_ttl                       = 86400
#    }
#
#    restrictions {
#        geo_restriction {
#            restriction_type          = "none"
#            }
#    }
#
#    price_class                       = "${var.cloudfront_price_class}"
#
#    viewer_certificate {
#        # cloudfront_default_certificate  = true
#        ssl_support_method            = "sni-only"
#        acm_certificate_arn           = "${data.aws_acm_certificate.certificate.arn}"
#    }
#
#    tags = {
#        description                   = "${var.component_name}-cdn"
#        Name                          = "${var.component_name}-cdn"
#        app                           = "${var.common_value}"
#    }
#}

resource "aws_security_group" "ingress-ssh-test" {
  name   = "allow-ssh-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "${trimspace(data.http.myip.response_body)}/32"
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

resource "aws_security_group" "ingress-web" {
  name   = "allow-web-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 8080
    to_port   = 8080
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

resource "aws_eip" "ip-test-env" {
  instance = "${aws_spot_instance_request.test_worker.spot_instance_id}"
  domain   = "vpc"
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

resource "aws_spot_instance_request" "test_worker" {
   ami                    = tolist([ for v in jsondecode(data.http.arch_ami.response_body).arch_amis : v.ami if v.type=="std" && v.region == data.aws_region.current.name ])[0]
  spot_price             = data.aws_ec2_spot_price.instance.spot_price
  instance_type          = var.instance_type
  spot_type              = "one-time"
  wait_for_fulfillment   = "true"
  key_name               = "${aws_key_pair.spot_key.key_name}"

  root_block_device {
    volume_size = 100
  }

  lifecycle {
    ignore_changes = [security_groups]
  }

  security_groups = ["${aws_security_group.ingress-ssh-test.id}", "${aws_security_group.ingress-web.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"
}

output "instance_ip_addr" {
    value = aws_spot_instance_request.test_worker.public_dns
}

data "aws_region" "current" {}

data "http" "arch_ami" {
  url = "https://5nplxwo1k1.execute-api.eu-central-1.amazonaws.com/prod/latest"
}

data "aws_ec2_spot_price" "instance" {
  instance_type     = var.instance_type
  availability_zone = "us-east-1a"

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}
