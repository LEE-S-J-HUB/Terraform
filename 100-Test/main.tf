locals{
    instance = [
        {
            identifier = "N1"
            availability_zone = "ap-northeast-2a"
            ebs_block_device = [
                {
                    identifier = 1
                    size = 100
                },
                {
                    identifier = 2
                    size = 200
                }
            ]
        },
        {
            identifier = "N2"
            ebs_block_device = [
                {
                    identifier = 1
                    size = 100
                },
                {
                    identifier = 2
                    size = 200
                }
            ]
        }
    ]
}

locals {
    ebs_block_list = [
        for key in local.instance : [
            for key2 in key.ebs_block_device : "${key.identifier},${key2.identifier}" 
        ]
    ]
}

# resource "aws_ebs_volume" "this" {
#     for_each = {for instance in local.instance : instance.identifier => instance }
#     provider = aws.test
#     availability_zone = each.value.availability_zone
#     dynamic "ebs_block_device" {
#         for_each        = each.value.ebs_block_device
#         iterator        = ebs_block_device
#         content {
#             size                = ebs_block_device.value.size
#             type                = "gp2"
#             kms_key_id          = ""
#             encrypted           = true       
#             tags = {
#                 Name      = "mysql"
#                 Role      = "db"
#                 Terraform = "true"
#                 FS        = "xfs"
#             }     
#         }
#     }    
# }