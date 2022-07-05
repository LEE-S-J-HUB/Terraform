locals{
    instance = [
        {
            identifier = "N1"
            ebs_volume = [
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
            ebs_volume = [
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
            for key2 in key.ebs_volume : "${key.identifier},${key2.identifier}" 
        ]
    ]
}
data "ebs_list" {
  
}