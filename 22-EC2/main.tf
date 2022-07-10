locals {
    tags        = data.terraform_remote_state.local.outputs.global_environment_tags
    sub_ids         = data.terraform_remote_state.VPC_Subnet.outputs.sub_ids
    scg_ids         = data.terraform_remote_state.SecurityGroup.outputs.scg_ids
    # kms key arn으로 작성 필요
    ec2_default_user_data   = <<EOF
#cloud-config
system_info:
  default_user:
    name: sysadmin
    gecos: sysadmin
    uid: "1020"

ssh_pwauth: true

chpasswd:
  expire: true

chpasswd:
  list:
    - sysadmin:sysadmin

package_update: true
package_upgrade: true
packages:
 - awscli
 - nvme-cli

ntp:
  enabled: true
  ntp_client: chrony
  servers:
    - 169.254.169.123

timezone: ROK
#timezone: Asia/Seoul

runcmd:
  - [ sed, -i, 's/#Port 22/Port 10022/g', /etc/ssh/sshd_config ]
  - [ systemctl, restart, sshd ]
  - [ sed, -i, 's/name: ec2-user/name: sysadmin/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/lock_passwd: true/lock_passwd: false/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/gecos: EC2 Default User/gecos: sysadmin/g', /etc/cloud/cloud.cfg ]
  - [ sed, -i, 's/ssh_pwauth:   false/ssh_pwauth:   true/g', /etc/cloud/cloud.cfg ]

hostname: test
manage_etc_hosts: true

output:
    init:
        output: "> /var/log/cloud-init.out"
        error: "> /var/log/cloud-init.err"
    config: "tee -a /var/log/cloud-config.log"
    final:
        - ">> /var/log/cloud-final.out"
        - "/var/log/cloud-final.err"
EOF
}

module "create-ec2_instance" {
    source = "../00-Module/EC2_New"
    providers = {
      aws = aws.test
     }
    ec2 = [
        {
            identifier              = format("${local.tags["ec2"].Name}-%s", "bestion")
            ami                     = "ami-02de72c5dc79358c9"
            instance_type           = "t2.micro"
            availability_zone       = "ap-northeast-2a"
            subnet_id               = local.sub_ids["${format("${local.tags["sub"].Name}-%s", "lb-01a")}"]
            vpc_security_group_ids  = [local.scg_ids["${format("${local.tags["scg"].Name}-%s", "bestion")}"]]
            user_data               = local.ec2_default_user_data
            tags                    = merge(local.tags["ec2"], { "Name" = format("${local.tags["ec2"].Name}-%s", "bestion") } )
            private_ip              = ""
            root_block_device = [
                {
                    volume_type             = "gp2"
                    volume_size             = 50
                    iops                    = null
                    delete_on_termination   = true
                    encrypted               = true
                    kms_key_id              = ""
                    tags = merge(local.tags["ebs"], { "Name" = format("${local.tags["ebs"].Name}-%s", "bestion") } )
                }
            ]
            ebs_block_device = [
                {
                    device_name             = "/dev/xvdb"
                    volume_type             = "gp2"
                    volume_size             = 50
                    iops                    = null
                    delete_on_termination   = true
                    encrypted               = false
                    kms_key_id              = ""
                    tags = merge(local.tags["ebs"], { "Name" = format("${local.tags["ebs"].Name}-%s", "bestion") } )
                },
                {
                    device_name             = "/dev/xvdc"
                    volume_type             = "gp2"
                    volume_size             = 50
                    iops                    = null
                    delete_on_termination   = true
                    encrypted               = false
                    kms_key_id              = ""
                    tags = merge(local.tags["ebs"], { "Name" = format("${local.tags["ebs"].Name}-%s", "bestion") } )
                }
            ]
            launch_template = {
                Existence = "no"
            }
        }
    ]
    eips        = [
        {
            identifier      = format("${local.tags["eip"].Name}-%s", "bestion")
            ec2_identifier  = format("${local.tags["ec2"].Name}-%s", "bestion") 
            tags = merge(local.tags["eip"], { "Name" = format("${local.tags["eip"].Name}-%s", "bestion") } )
        }
    ]
}