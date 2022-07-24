locals {
    tags      = data.terraform_remote_state.local.outputs.global_environment_tags
    scg_list  = data.terraform_remote_state.SecurityGroup.outputs.scg_ids
    sub_list  = data.terraform_remote_state.VPC_Subnet.outputs.sub_ids
}

module "aws_lb" {
    source  = "../00-Module/LB/"
    providers = {
      aws = aws.test
     }
    alb = [
        {
            name                        = format("${local.tags["alb"].Name}-%s", "web")
            internal                    = false
            security_groups             = [local.scg_list["${format("${local.tags["scg"].Name}-%s", "xalb")}"]]
            # subnets                     = [local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01a")}"], local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01c")}"]]
            subnet_mapping              = [
                {
                    subnet_id               = local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01a")}"]
                },
                {
                    subnet_id   = local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01c")}"]

                }
            ]
            enable_deletion_protection  = false
            tags = merge(local.tags["alb"], { "Name" = format("${local.tags["alb"].Name}-%s", "web") } )
        }
    ]
    nlb = [
        {
            name                        = format("${local.tags["nlb"].Name}-%s", "web")
            internal                    = true
            # subnets                     = [local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01a")}"], local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01c")}"]]
            subnet_mapping              = [
                {
                    subnet_id   = local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01a")}"]
                    private_ipv4_address    = "172.168.20.16"
                },
                {
                    subnet_id   = local.sub_list["${format("${local.tags["sub"].Name}-%s", "lb-01c")}"]
                    private_ipv4_address    = "172.168.20.46"
                }
            ]
            enable_deletion_protection  = false
            tags = merge(local.tags["alb"], { "Name" = format("${local.tags["nlb"].Name}-%s", "web") } )
        }
    ]
}