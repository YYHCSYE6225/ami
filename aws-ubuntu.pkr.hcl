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
    ]
  }
}
