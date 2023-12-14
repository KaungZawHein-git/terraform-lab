variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  default     = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  default     = "10.1.3.0/24"
}

variable "availability_zone_a" {
  description = "Availability Zone A"
  default     = "us-east-1d"
}

variable "availability_zone_b" {
  description = "Availability Zone B"
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for instances"
  default     = "ami-0fc5d935ebf8bc3bc"
}

variable "key_name" {
  description = "Key name for instances"
  default     = "vmnewkey"
}
