#Load Balancer

resource "aws_lb" "cpstn_loadBalancer" {
  name                              = "myWebserver-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.Deham9_Public_SG.id]
  subnets                           = [aws_subnet.cpstn_publicsubnet_1.id, aws_subnet.Deham9_Public_SG.id]
  enable_deletion_protection        = false
    tags = {
        Environment                 = "production"
  }
}

#Target Group

resource "aws_lb_target_group" "cpstn-target-group" {
  name                              = "CPUtest-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.Deham9-VPC.id
}

#Listener

resource "aws_lb_listener" "cpstn-listener" {
  load_balancer_arn                 = aws_lb.cpstn_loadBalancer.arn
  port                              = 80
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.cpstn-target-group.arn
  }
}
