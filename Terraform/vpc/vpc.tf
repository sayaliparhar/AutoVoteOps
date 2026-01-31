# vpc creation

resource "aws_vpc" "terra-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "autovote_vpc"
  }
}

# Subnet creation
resource "aws_subnet" "pub-sub-1" {
    vpc_id = aws_vpc.terra-vpc.id
    cidr_block = "10.0.0.0/18"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "public_subnet_1"
    }
    depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "pub-sub-2" {
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = "10.0.192.0/18"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "public_subnet_2"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "priv-sub-1" {
    vpc_id = aws_vpc.terra-vpc.id
    cidr_block = "10.0.128.0/18"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "private_subnet_1"
    }
    depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "priv-sub-2" {
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = "10.0.64.0/18"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private_subnet_2"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

# Internet gateway creation
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.terra-vpc.id
    tags = {
      Name = "Internet-Gateway"
    }
  
}

# Elastic-ip creation
resource "aws_eip" "terra-eip" {
    region = "ap-south-1"
    tags = {
        Name = "Nat-Eip"
    }
  
}

# Nat gateway association
resource "aws_nat_gateway" "terra-nat" {
  allocation_id = aws_eip.terra-eip.id
  subnet_id = aws_subnet.pub-sub-1.id
  tags = {
    Name = "Nat-Gateway"
  }
  depends_on = [ aws_eip.terra-eip, aws_subnet.pub-sub-1 ]
}

# Public-route-table creation
resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.terra-vpc.id
    tags = {
      Name = "Public-route-table"
    }
  depends_on = [ aws_vpc.terra-vpc ]
}

# Private-route-table creation
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "private-route-table"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

# Public-route-table association
resource "aws_route_table_association" "public_route_association_1" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id = aws_subnet.pub-sub-1.id
    depends_on = [ aws_route_table.public-route-table, aws_subnet.pub-sub-1 ]
}

resource "aws_route_table_association" "public_route_association_2" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.pub-sub-2.id
  depends_on = [ aws_route_table.public-route-table, aws_subnet.pub-sub-2]
}

# Private-route-table association
resource "aws_route_table_association" "private_route_association_1" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.priv-sub-1.id
  depends_on = [ aws_route_table.private_route_table,aws_subnet.priv-sub-1 ]
}

resource "aws_route_table_association" "private_route_association_2" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.priv-sub-2.id
  depends_on = [ aws_route_table.private_route_table ,aws_subnet.priv-sub-2 ]
}

# public-routes association
resource "aws_route" "public_routes" {
  route_table_id = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [ aws_route_table.public-route-table, aws_internet_gateway.igw ]
}

# Private-routes association
resource "aws_route" "private_routes" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.terra-nat.id
  depends_on = [ aws_route_table.private_route_table, aws_nat_gateway.terra-nat ]
}