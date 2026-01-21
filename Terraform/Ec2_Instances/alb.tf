# The Load Balancer
resource "aws_lb" "voting_app_alb" {
  name = "voting-app-alb"
  internal = false 
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups = [var.alb_sg]
  subnets = [var.pub_sub_1, var.priv_sub_3]
}

# The Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.voting_app_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.voting_tg.arn
  }
  depends_on = [ aws_lb.voting_app_alb ]
}

# The Target Group (Points to your K8s NodePort)
resource "aws_lb_target_group" "voting_tg" {
  name = "voting-app-tg"
  port = 31000
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path                = "/"
    port                = "31000"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "worker_attachment" {
  target_group_arn = aws_lb_target_group.voting_tg.arn
  target_id = aws_instance.k8s-worker.id 
  port = 31000
  depends_on = [ aws_lb_target_group.voting_tg ]
}

