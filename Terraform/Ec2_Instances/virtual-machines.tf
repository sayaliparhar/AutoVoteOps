# Jenkins vm

resource "aws_instance" "jenkins-master" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t2.medium"
  key_name = aws_key_pair.terra-key.id
  subnet_id = var.pub_sub_1
  vpc_security_group_ids = [ var.jenkins_vm_sg ]
  associate_public_ip_address = true
  user_data = file("${path.module}/Software-Installation-script/Jenkins-vm-script.sh")
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "Jenkins-Master-VM"
  }
}

# k8s-master-vm
resource "aws_instance" "k8s-master" {
  ami = "ami-031bf0e18d2893e79"
  instance_type = "t2.medium"
  key_name = aws_key_pair.terra-key.id
  subnet_id = var.priv_sub_1
  vpc_security_group_ids = [var.k8s_master_vm_sg]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.k8s_profile.name
  user_data = file("${path.module}/Software-Installation-script/k8s-master-script.sh")
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "K8s-Master-VM"
  }
  depends_on = [ aws_iam_instance_profile.k8s_profile ]
}

# k8s-worker-sg
resource "aws_instance" "k8s-worker" {
  ami = "ami-031bf0e18d2893e79"
  instance_type = "t2.medium"
  key_name = aws_key_pair.terra-key.id
  subnet_id = var.priv_sub_2
  vpc_security_group_ids = [ var.k8s_worker_vm_sg ]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.k8s_profile.name
  user_data = file("${path.module}/Software-Installation-script/k8s-worker-script.sh")
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "K8s-Worker-VM"
  }
  depends_on = [ aws_iam_instance_profile.k8s_profile ]
}

resource "aws_iam_instance_profile" "k8s_profile" {
  name = "cluster-instance-profile"
  role = "Cluster-Role"
}
