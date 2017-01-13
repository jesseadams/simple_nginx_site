variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

variable "ami" {
  description = "AMI to use for launch configuration"
  default = "ami-2a34e94a"
}

variable "availability_zones" {
  default     = "us-west-2a,us-west-2b,us-west-2c"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  description = "Name of AWS key pair"
  default = "jesse"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "2"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "2"
}

variable "hosted_zone_id" {
  default     = "ZBGSCPNBMP09T"
  description = "The Route53 zone id for DNS records"
}

variable "dns_record" {
  default     = "stelligent.techno-geeks.org"
  description = "The DNS record for the ELB"
}
