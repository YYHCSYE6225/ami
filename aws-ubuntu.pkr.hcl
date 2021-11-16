variable "ami_name" {
  type = string
}
variable "region" {
  type = string
}
variable "source_ami" {
  type = string
}
variable "ssh_username" {
  type = string
}

variable "prod_id" {
  type = string
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_name}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami    = "${var.source_ami}"
  ssh_username  = "${var.ssh_username}"
  ami_users=["${var.prod_id}"]
}


build {
  name = "csye6225-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell"{
    inline=[
      "sudo apt-get purge libappstream4 -y",
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sleep 30",
      "sudo apt install default-jre -y",
      "sleep 30",
      "sudo apt install default-jdk -y",
      "sudo apt install ruby-full -y",
      "sudo apt install wget",
      "cd /home/ubuntu",
      "wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install",
      "chmod +x ./install",
      "sudo ./install auto",
      "sudo apt install net-tools",
      "sudo apt-get install collectd -y",
      "wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb",
      "sleep 30",
      "sudo dpkg -i -E ./amazon-cloudwatch-agent.deb",
      "sudo apt-get install nodejs -y",
      "git clone https://github.com/statsd/statsd.git",
      "cd statsd",
      "cp exampleConfig.js config.js"
    ]
  }
}
