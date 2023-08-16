
variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

#vpc:

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_instance_tenancy" {
  description = "Instance tenancy for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}


#pub_subnets:


variable "availability_zone_1" {
  description = "Availability Zone for Subnet 01"
  type        = string
}

variable "pub_subnet1_cidr" {
  description = "cidr block for Subnet 01"
  type        = string
}

variable "pub_subnet1_name" {
  description = "Name tag for the Subnet 01"
  type        = string
}


variable "availability_zone_2" {
  description = "Availability Zone for Subnet 02"
  type        = string
}

variable "pub_subnet2_cidr" {
  description = "cidr block for Subnet 02"
  type        = string
}

variable "pub_subnet2_name" {
  description = "Name tag for the Subnet 02"
  type        = string
}


#priv_subnets:

variable "availability_zone_3" {
  description = "Availability Zone for Subnet 03"
  type        = string
}

variable "priv_subnet1_cidr" {
  description = "cidr block for Subnet 03"
  type        = string
}

variable "priv_subnet1_name" {
  description = "Name tag for the Subnet 03"
  type        = string
}



variable "availability_zone_4" {
  description = "Availability Zone for Subnet 04"
  type        = string
}

variable "priv_subnet2_cidr" {
  description = "cidr block for Subnet 04"
  type        = string
}

variable "priv_subnet2_name" {
  description = "Name tag for the Subnet 04"
  type        = string
}


# pub_route_table:

variable "pub_route_table_name" {
  description = "Name tag for the public route table"
  type        = string
}


# priv_route_table:

variable "priv_route_table_name" {
  description = "Name tag for the private route table"
  type        = string
}


# public instance:

variable "pub_instance_ami" {
  description = "AMI ID for the public EC2 instance"
}

variable "pub_instance_type" {
  description = "Instance type for the public EC2 instance"
}

variable "pub_instance_key_name" {
  description = "Key pair name for the public EC2 instance"
}

variable "pub_instance_name" {
  description = "Name for the public EC2 instance"
}


# private instance:

# variable "priv_instance_ami" {
#  description = "AMI ID for the private EC2 instance"
#}

#variable "priv_instance_type" {
#  description = "Instance type for the private EC2 instance"
#}

#variable "priv_instance_key_name" {
#  description = "Key pair name for the private EC2 instance"
#}

#variable "priv_instance_name" {
#  description = "Name for the private EC2 instance"
#}
