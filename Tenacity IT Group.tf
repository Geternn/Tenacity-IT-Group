# Create a VPC
resource "aws_vpc" "Tenacity_IT" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Tenacity-IT-Group"
  }
}

# Create public subnets
resource "aws_subnet" "Prod_pub_sub1" {  
  vpc_id                  = aws_vpc.Tenacity_IT.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  

  tags = {
    Name = "pub-sub1"
  }
}

resource "aws_subnet" "Prod_pub_sub2" {  
  vpc_id     = aws_vpc.Tenacity_IT.id
  cidr_block = "10.0.3.0/24"  # ✅ Fixed CIDR block conflict

  tags = {
    Name = "pub-sub2"
  }
}

# Create private subnets
resource "aws_subnet" "Prod_priv_sub1" {  
  vpc_id     = aws_vpc.Tenacity_IT.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "priv-sub1"
  }
}

resource "aws_subnet" "Prod_priv_sub2" {  
  vpc_id     = aws_vpc.Tenacity_IT.id
  cidr_block = "10.0.4.0/24"  

  tags = {
    Name = "priv-sub2"
  }
}

# Create public route table
resource "aws_route_table" "Prod_pub_route_table" {
  vpc_id = aws_vpc.Tenacity_IT.id

  tags = {
    Name = "Prod-pub-route-table"
  }
}

# Create private route table
resource "aws_route_table" "Prod_priv_route_table" {
  vpc_id = aws_vpc.Tenacity_IT.id

  tags = {
    Name = "Prod-priv-route-table"
  }
}

# Create subnet associations
resource "aws_route_table_association" "prod_pub_association" {  
  subnet_id      = aws_subnet.Prod_pub_sub1.id
  route_table_id = aws_route_table.Prod_pub_route_table.id
}

resource "aws_route_table_association" "prod_priv_association" {  
  subnet_id      = aws_subnet.Prod_priv_sub1.id
  route_table_id = aws_route_table.Prod_priv_route_table.id
}

# Create Internet Gateway
resource "aws_internet_gateway" "Prod_igw" {
  vpc_id = aws_vpc.Tenacity_IT.id

  tags = {
    Name = "Prod-igw"
  }
}

# Create Internet Gateway route association
resource "aws_route" "Prod_igw_association" {
  route_table_id         = aws_route_table.Prod_pub_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Prod_igw.id  # ✅ Fixed misplaced quote
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "Prod_Nat_eip" {
  domain = "vpc"
}

# Create a NAT Gateway in the public subnet
resource "aws_nat_gateway" "Prod_Nat_gateway" {
  allocation_id = aws_eip.Prod_Nat_eip.id
  subnet_id     = aws_subnet.Prod_pub_sub1.id

  tags = {
    Name = "Prod-Nat-gateway"
  }
}

# Associate private subnet with private route table (NAT Gateway route)
resource "aws_route" "Prod_Nat_route" {
  route_table_id         = aws_route_table.Prod_priv_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Prod_Nat_gateway.id
}

resource "aws_route_table_association" "Prod_Nat_association" {
  subnet_id      = aws_subnet.Prod_priv_sub1.id
  route_table_id = aws_route_table.Prod_priv_route_table.id
}














