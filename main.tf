variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the VPC where the NAT Gateway and route table will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID in a public subnet for placing the NAT Gateway"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate with the route table"
  type        = list(string)
}

variable "nat_gateway_name" {
  description = "Name tag for the NAT Gateway"
  type        = string
  default     = "My-NAT-Gateway"
}

variable "route_table_name" {
  description = "Name tag for the private route table"
  type        = string
  default     = "Private-Route-Table"
}

variable "route_cidr_block" {
  description = "CIDR block for default route via NAT Gateway"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev-ops"
    Owner       = "Cra-week7"
  }
}