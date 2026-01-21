resource "aws_vpc" "terra-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "autovote_vpc"
  }
}

resource "aws_subnet" "pub-sub-1" {
    vpc_id = aws_vpc.terra-vpc.id
    cidr_block = "10.0.0.0/18"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Jenkins_subnet"
    }
    depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "priv-sub-1" {
    vpc_id = aws_vpc.terra-vpc.id
    cidr_block = "10.0.64.0/18"
    availability_zone = "ap-south-1b"
    tags = {
        Name = "private-K8s-subnet"
    }
    depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "priv-sub-2" {
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = "10.0.128.0/18"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-rds-A"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_subnet" "priv-sub-3" {
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = "10.0.192.0/18"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-rds-B"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.terra-vpc.id
    tags = {
      Name = "Internet-Gateway"
    }
  
}

resource "aws_eip" "terra-eip" {
    region = "ap-south-1"
    tags = {
        Name = "Nat-Eip"
    }
  
}

resource "aws_nat_gateway" "terra-nat" {
  allocation_id = aws_eip.terra-eip.id
  subnet_id = aws_subnet.pub-sub-1.id
  tags = {
    Name = "Nat-Gateway"
  }
  depends_on = [ aws_eip.terra-eip, aws_subnet.pub-sub-1 ]
}

resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.terra-vpc.id
    tags = {
      Name = "Public-route-table"
    }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "private-route-table"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_route_table_association" "public_route_association_1" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id = aws_subnet.pub-sub-1.id
    depends_on = [ aws_route_table.public-route-table, aws_subnet.pub-sub-1 ]
}

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

resource "aws_route_table_association" "private_route_association_3" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.priv-sub-3.id
  depends_on = [ aws_route_table.private_route_table, aws_subnet.priv-sub-3 ]
}

resource "aws_route" "public_routes" {
  route_table_id = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [ aws_route_table.public-route-table, aws_internet_gateway.igw ]
}

resource "aws_route" "private_routes" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.terra-nat.id
  depends_on = [ aws_route_table.private_route_table, aws_nat_gateway.terra-nat ]
}