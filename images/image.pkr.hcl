packer{
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_source_ami" {
  default = "amzn2-ami-kernel-5.10-hvm-2.0.20240521.0-x86_64-gp2"
}

variable "aws_instance_type" {
  default = "t2.small"
}

variable "ami_version" {
  default = "1.0.6"
}

variable "ami_name" {
  default = "ami-stack-6.0"
}

variable "name" {
  type    = string
  default = ""
}

variable "component" {
  default = "clixx"
}


variable "aws_accounts" {
  type = list(string)
  default= ["721636561061"]
}

variable "ami_regions" {
  type = list(string)
  default =["us-east-1"]
}

data "amazon-ami" "source_ami" {
  filters = {
    name = "${var.aws_source_ami}"
  }
  most_recent = true
  owners      = ["137112412989","amazon"]
  region      = "${var.aws_region}"
}



variable "aws_region" {
  default = "us-east-1"
}


# locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }


# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.


source "amazon-ebs" "amazon_ebs" {
  # assume_role {
  #   role_arn     = "arn:aws:iam::530958276242:role/Engineer"
  # }
  ami_name                = "${var.ami_name}"
  ami_regions             = "${var.ami_regions}"
  ami_users               = "${var.aws_accounts}"
  snapshot_users          = "${var.aws_accounts}"
  encrypt_boot            = false
  instance_type           = "${var.aws_instance_type}"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    encrypted             = true
    //kms_key_id            = "27b16aa3-868a-44d7-842e-9cfa35257529"  //This is for "Management 1" account in order to run locally.
    kms_key_id            =  "f0c778bf-1667-4c48-a112-ae33dce62913" // This is for "Automation 1" account in order to push to GitHub
                                                                    // and run on Jenkins.
                                                                    //Hash out either one, depending on where you want to run Packer.
                                                                    //Later, incorporate a shell script in Jenkinsfile-1 to make the 
                                                                    //change 
    volume_size           = 10
    volume_type           = "gp2"
  }
  region                  = "${var.aws_region}"
  source_ami              = "${data.amazon-ami.source_ami.id}"
  ssh_pty                 = true
  ssh_timeout             = "5m"
  ssh_username            = "ec2-user"
}


# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.amazon_ebs"]
  provisioner "shell" {
    script = "../scripts/setup.sh"
  }
}
