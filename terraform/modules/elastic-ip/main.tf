resource "aws_eip" "web" {

  domain = "vpc"

  instance = var.instance_id

  tags = {
    Name = "${var.project_name}-${var.environment}-eip"
  }

}
