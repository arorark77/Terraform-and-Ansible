##Install terraform, then run terraform init, terraform plan, verify everything in plan,
## then terraform apply....once done..Terraform destroy to destroy the resources in aws.
#--------Provider---------------#

provider "aws" {
region = "us-east-1"
}

#---------Resource_aws_instance-------------#

resource "aws_instance" "example" {
ami = "ami-0323c3dd2da7fb37d"
instance_type = "t2.nano"
vpc_security_group_ids = ["${aws_security_group.instance.id}"]

user_data = <<EOF
#!/bin/bash
echo "Hello, World" > index.html 
nohup busybox httpd -f -p "${var.server_port}" &
EOF

}

#-------------Resource_aws_security-group-----------------#

resource "aws_security_group" "instance" {
name = "terraform-example-instance"

ingress {
	from_port = "${var.server_port}"
	to_port = "${var.server_port}"
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}

lifecycle {
create_before_destroy = true
}
}

#---------------variable---------------------------------#

variable "server_port" {
description = "the port the server will use for http requests"
default = 8080
}

#------------------Output-----------------------------#

output "public_ip" {
value = "${aws_instance.example.public_ip}"
}

