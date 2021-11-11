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
      "cd /opt",
      "sudo touch cloudwatch-config.json",
      "sudo bash -c 'cat>cloudwatch-config.json<<EOF
{
    "agent": {
        "metrics_collection_interval": 10,
        "logfile": "/var/logs/amazon-cloudwatch-agent.log"
    },
    "metrics":{
        "metrics_collected":{
            "collectd":{
            "name_prefix":"My_collectd_metrics_",
            "metrics_aggregation_interval":120
            },
            "mem": {
                "measurement": [
                    "used_percent",
                    "total"
                ]
            }

        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/opt/tomcat/logs/csye6225.log",
                        "log_group_name": "csye6225",
                        "log_stream_name": "webapp",
                        "timezone": "UTC"
                    }
                ]
            }
        },
        "log_stream_name": "cloudwatch_log_stream"
    }
}
EOF'"
    ]
  }
}
