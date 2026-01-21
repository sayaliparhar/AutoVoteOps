# Jenkins master securiy-group-details

resource "aws_security_group" "terra-jenkins" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "Jenkins-sg"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-jenkins-ssh" {
  security_group_id = aws_security_group.terra-jenkins.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-jenkins ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-jenkins-8080" {
  security_group_id = aws_security_group.terra-jenkins.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-jenkins ]
}

resource "aws_vpc_security_group_egress_rule" "egress-jenkins-all" {
  security_group_id = aws_security_group.terra-jenkins.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
  depends_on = [ aws_security_group.terra-jenkins ]
}

# K8s master securiy-group-details

resource "aws_security_group" "terra-k8s-master" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "K8s-master-sg"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-master-ssh" {
  security_group_id = aws_security_group.terra-k8s-master.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
  depends_on = [ aws_security_group.terra-k8s-master ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-master-6443" {
  security_group_id = aws_security_group.terra-k8s-master.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 6443
  to_port = 6443
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-master ] 
} 


resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-master-179"{
  security_group_id = aws_security_group.terra-k8s-master.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 179
  to_port = 179
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-master ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-all-from-k8s-worker" {
  security_group_id = aws_security_group.terra-k8s-master.id
  referenced_security_group_id = aws_security_group.terra-k8s-worker.id
  ip_protocol = -1
  depends_on = [ aws_security_group.terra-k8s-master]
}

resource "aws_vpc_security_group_egress_rule" "egress-k8s-master-all" {
  security_group_id = aws_security_group.terra-k8s-master.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
  depends_on = [ aws_security_group.terra-k8s-master ]
}

# K8s worker securiy-group-details

resource "aws_security_group" "terra-k8s-worker" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "k8s-worker-sg"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-worker-ssh" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-worker-10250" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 10250
  to_port = 10250
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-worker-179" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 179
  to_port = 179
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-k8s-worker-31000" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 31000
  to_port = 31000
  ip_protocol = "tcp"
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-all-from-k8s-master" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  referenced_security_group_id = aws_security_group.terra-k8s-master.id
  ip_protocol = -1
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

resource "aws_vpc_security_group_egress_rule" "egress-k8s-worker-all" {
  security_group_id = aws_security_group.terra-k8s-worker.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
  depends_on = [ aws_security_group.terra-k8s-worker ]
}

# RDS securiy-group-details
resource "aws_security_group" "terra-rds" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "RDS-SG"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-rds-3306" {
  security_group_id = aws_security_group.terra-rds.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 3306
  to_port = 3306
  depends_on = [ aws_security_group.terra-rds ]
}

resource "aws_vpc_security_group_egress_rule" "egress-rds-all" {
  security_group_id = aws_security_group.terra-rds.id
  ip_protocol = -1
  cidr_ipv4 = "0.0.0.0/0"
  depends_on = [ aws_security_group.terra-rds ]
}

# ALB securiy-group-details

resource "aws_security_group" "terra-alb" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "ALB-SG"
  }
  depends_on = [ aws_vpc.terra-vpc ]
}

resource "aws_vpc_security_group_ingress_rule" "ingress-alb-80" {
  security_group_id = aws_security_group.terra-alb.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  depends_on = [ aws_security_group.terra-alb ]
}

resource "aws_vpc_security_group_egress_rule" "egress-alb-all" {
  security_group_id = aws_security_group.terra-alb.id
  ip_protocol = -1
  cidr_ipv4 = "0.0.0.0/0"
  depends_on = [ aws_security_group.terra-alb ]
}