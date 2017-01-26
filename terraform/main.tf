provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "web-elb" {
  name = "simple-web-elb"
  subnets  = ["${aws_subnet.us-west-2a-public.id}", "${aws_subnet.us-west-2b-public.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_autoscaling_group" "web-asg" {
  vpc_zone_identifier  = ["${aws_subnet.us-west-2a-public.id}", "${aws_subnet.us-west-2b-public.id}"]
  name                 = "simple-web-asg-${aws_launch_configuration.web-lc.name}"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  wait_for_elb_capacity = "${var.asg_desired}"
  launch_configuration = "${aws_launch_configuration.web-lc.name}"
  load_balancers       = ["${aws_elb.web-elb.name}"]
  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "web-lc" {
  name_prefix          = "simple-web-lc-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.simple.id}"]
  key_name        = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "simple" {
  name        = "simple_static_webpage"
  description = "Allow port 80 inbound"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.dns_record}"
  type = "A"

  alias {
    name = "${aws_elb.web-elb.dns_name}"
    zone_id = "${aws_elb.web-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "us-west-2a-public" {
    vpc_id = "${aws_vpc.default.id}"
    map_public_ip_on_launch = true

    cidr_block = "10.0.0.0/24"
    availability_zone = "us-west-2a"
}

resource "aws_subnet" "us-west-2b-public" {
    vpc_id = "${aws_vpc.default.id}"
    map_public_ip_on_launch = true

    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-2b"
}

resource "aws_route_table" "us-west-2-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
}

resource "aws_route_table_association" "us-west-2a-public" {
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    route_table_id = "${aws_route_table.us-west-2-public.id}"
}

resource "aws_route_table_association" "us-west-2b-public" {
    subnet_id = "${aws_subnet.us-west-2b-public.id}"
    route_table_id = "${aws_route_table.us-west-2-public.id}"
}
