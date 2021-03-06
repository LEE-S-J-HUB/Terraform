locals {
    tags        = data.terraform_remote_state.local.outputs.global_environment_tags
    vpc_ids     = data.terraform_remote_state.VPC_Subnet.outputs.vpc_ids
    ec2_ids     = data.terraform_remote_state.EC2.outputs.ec2_instaces_ids
    # 
    health_check    = {
        "ALB"   = {
            "enabled"               = true              # Whether health checks are enabled.
            "healthy_threshold"     = 5                 # Number of consecutive health checks successes required before considering an unhealthy target healthy
            "interval"              = 30                # Approximate amount of time, in seconds, between health checks
            "matcher"               = "200"             # Response codes to use when checking for a healthy responses from a target.
            "path"                  = "/"               # Destination for the health check request
            "port"                  = "traffic-port"    # Port to use to connect with the target
            "protocol"              = "HTTP"            # Protocol to use to connect with the target.
            "timeout"               = 5                 # Amount of time, in seconds, during which no response means a failed health check.
            "unhealthy_threshold"   = 2                 # Number of consecutive health check failures required before considering the target unhealthy.
        },
        "NLB"   = {                                     
            "enabled"               = true              # 
            "healthy_threshold"     = 3                 # TCP
            "interval"              = 30                # 
            "matcher"               = null              # 
            "path"                  = null              # 
            "port"                  = "traffic-port"    # 
            "protocol"              = "TCP"             # 
            "timeout"               = 10                # 
            "unhealthy_threshold"   = 3                 # 
        }
    }
}

module "lb_TargetGroup" {
    source = "../00-Module/lb_TargetGroup"
    providers = {
      aws = aws.test
     }
    # resource : aws_lb_target_group
    # resource creation method : for_each | key : name
    # Main Value = "proocol-port-target_type"
    tgs     = [
        {
            name            = format("${local.tags["tg"].Name}-%s", "web")
            Main_Value      = "HTTP-80-instance"
            vpc_id          = local.vpc_ids["${format("${local.tags["vpc"].Name}-%s", "pub")}"]
            target_id       = [local.ec2_ids[format("${local.tags["ec2"].Name}-%s", "web")]]
            port            = 80
        }
    ]
}