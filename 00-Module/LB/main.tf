resource "aws_lb" "alb" {
    for_each                    = { for alb in var.alb : alb.name => alb    }
    name                        = lookup(each.value, "name", null)
    internal                    = each.value.internal
    load_balancer_type          = "application"
    security_groups             = each.value.security_groups
    # subnets                     = each.value.subnets
    enable_deletion_protection  = each.value.enable_deletion_protection
    dynamic "subnet_mapping" {
        for_each    = each.value.subnet_mapping
        content {
            subnet_id               = lookup(subnet_mapping.value, "subnet_id", null)
            private_ipv4_address    = lookup(subnet_mapping.value, "private_ipv4_address", null)
            allocation_id           = lookup(subnet_mapping.value, "allocation_id", null)
            ipv6_address            = lookup(subnet_mapping.value, "ipv6_address", null)
            outpost_id              = lookup(subnet_mapping.value, "outpost_id", null)
        }
    }
}

resource "aws_lb" "nlb" {
    for_each                    = { for nlb in var.nlb : nlb.name => nlb    }
    name                        = lookup(each.value, "name", null)
    internal                    = each.value.internal
    load_balancer_type          = "network"
    # subnets                     = each.value.subnets
    enable_deletion_protection  = each.value.enable_deletion_protection
    dynamic "subnet_mapping" {
        for_each    = each.value.subnet_mapping
        content {
            subnet_id               = lookup(subnet_mapping.value, "subnet_id", null)
            private_ipv4_address    = lookup(subnet_mapping.value, "private_ipv4_address", null)
            allocation_id           = lookup(subnet_mapping.value, "allocation_id", null)
            ipv6_address            = lookup(subnet_mapping.value, "ipv6_address", null)
            outpost_id              = lookup(subnet_mapping.value, "outpost_id", null)
        }
    }
}