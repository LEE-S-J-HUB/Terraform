# 10-VPC_Subnet Description
# Create AWS Resource List VPC, Insternet Gateway, Subnet, NAT Gateway, Elastic IP(NAT Gateway)


# Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
locals {
    project_code = "tra01"
    Region       = "an2"
    Environment  = "prd"
    Services     = ["vpc","sub","igw","ngw","eip","rt","scg","ec2","tg"]
    # Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    tags    = {for key in local.Services : key => {
            "Name" = lower(format("%s-%s-%s-%s", key, local.Region, local.project_code, local.Environment))
            "ENV"  = lower("${local.Environment}")
        }
    }
}
    # tags         = {
    #     "vpc"   = {
    #         "Name"  = lower(format("vpc-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "igw"   = {
    #         "Name"  = lower(format("igw-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "sub"   = {
    #         "Name"  = lower(format("sub-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "ngw"   = {
    #         "Name"  = lower(format("ngw-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "eip"   = {
    #         "Name"  = lower(format("eip-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "rt"   = {
    #         "Name"  = lower(format("rt-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "scg"     = {
    #         "Name"  = lower(format("scg-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #         "ENV"   = "${local.Environment}"
    #     }
    #     "ec2"   = {
    #         "Name"  = lower(format("ec2-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #     }
    #     "tg"   = {
    #         "Name"  = lower(format("tg-%s-%s-%s", local.Region, local.project_code, local.Environment))
    #     }
    # }