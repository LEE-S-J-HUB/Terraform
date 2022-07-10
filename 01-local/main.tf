


# Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
locals {
    project_code = "tra01"
    Region       = "an2"
    Environment  = "prd"
    Services     = ["vpc","sub","igw","ngw","eip","rt","scg","ec2","tg","ebs"]
    # Naming Rule : {Service}-{Region}-{Project_Code}-{Environment}-{Pupose}
    tags    = {for key in local.Services : key => {
            "Name" = lower(format("%s-%s-%s-%s", key, local.Region, local.project_code, local.Environment))
            "ENV"  = lower("${local.Environment}")
        }
    }
}
