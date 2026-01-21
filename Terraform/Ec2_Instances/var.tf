#subnet-ids

variable "pub_sub_1" {
  type = string
}

variable "priv_sub_1" {
  type = string
}

variable "priv_sub_2" {
  type = string
}

variable "priv_sub_3" {
  type = string
}

# security-group-ids

variable "jenkins_vm_sg" {
  type = string
}

variable "k8s_master_vm_sg" {
  type = string
}

variable "k8s_worker_vm_sg" {
  type = string
}

variable "rds_sg" {
  type = string
}

variable "alb_sg" {
  type = string
}

# vpc id
variable "vpc_id" {
  type = string
}