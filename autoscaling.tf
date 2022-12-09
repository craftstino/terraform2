
resource "aws_launch_template" "terraformtemp" {
  name = "terraformtemp"
   
  #disable_api_stop        = true
  #disable_api_termination = true
  instance_type = "t2.micro"
  
  image_id = "ami-096800910c1b781ba"

  network_interfaces {
    subnet_id = aws_subnet.terraformpublic1.id
    security_groups = [aws_security_group.BH-SG.id]
  }

  key_name = "TF_key"

  depends_on = [
    aws_key_pair.TF_key,tls_private_key.rsa,local_file.TF-key
  ]

}

resource "aws_autoscaling_group" "terraformscaling" {
  name = "autoscaling"
  availability_zones = ["eu-west-1a"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
 

  launch_template {
    id      = aws_launch_template.terraformtemp.id
    version = "$Latest"
  }

}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "terraformore80"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terraformscaling.name
  }

  alarm_actions     = [aws_autoscaling_policy.terraformpolicymore.arn]

}

resource "aws_cloudwatch_metric_alarm" "terraformlower" {
  alarm_name                = "terraforlower50"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terraformscaling.name
  }

  alarm_actions     = [aws_autoscaling_policy.terraformpolicylower.arn]
  }

resource "aws_autoscaling_policy" "terraformpolicymore" {
  name = "test2"
  autoscaling_group_name = aws_autoscaling_group.terraformscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = 300
}

resource "aws_autoscaling_policy" "terraformpolicylower" {
  name = "test1"
  autoscaling_group_name = aws_autoscaling_group.terraformscaling.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = 300
}


