resource "aws_instance" "mongodb" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.subnet_id

  associate_public_ip_address = false

  key_name = var.key_name

  iam_instance_profile = var.instance_profile_name

  vpc_security_group_ids = [var.security_group_id]

  metadata_options {

    http_endpoint = "enabled"

    http_tokens = "required"

  }

  root_block_device {

    volume_size = 20

    volume_type = "gp3"

    encrypted = true

  }

  tags = {

    Name = "${var.project_name}-${var.environment}-mongodb"

    Role = "MongoDB"

  }

}