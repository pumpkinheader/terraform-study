# Create a new load balancer
resource "aws_elb" "bar" {
  name = "${var.service.name}-elb"
  subnets = module.vpc.public_subnets

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 10
    timeout             = 10
    target              = "HTTP:8000/"
    interval            = 300
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 10

  tags = {
    Terraform = "true"
    Environment = var.service.env
  }
}