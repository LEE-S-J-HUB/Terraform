terraform {
    required_providers {
      aws = {
          version = "~>3.0"
      }
    }
    backend "s3" {
        bucket  = "s3-an2-lsj-dev-terraform"
        key     = "tra01/25-LB_TargetGroup.tfstate"
        region = "ap-northeast-2"
        encrypt = true
        profile = "MFA"
    }
}

provider "aws" {
    region  = "ap-northeast-2"
    profile = "MFA"
}

provider "aws" {
  alias  = "test"
  profile = "TEST"
  region  = "ap-northeast-2"
}


data "terraform_remote_state" "local" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="tra01/01-local.tfstate"
        encrypt = true
        profile = "MFA"
    }
}

data "terraform_remote_state" "VPC_Subnet" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="tra01/10-VPC_Subnet.tfstate"
        encrypt = true
        profile = "MFA"
    }
}

data "terraform_remote_state" "EC2" {
    backend = "s3"
    config = {
        bucket = "s3-an2-lsj-dev-terraform"
        region = "ap-northeast-2"
        key ="tra01/21-EC2.tfstate"
        encrypt = true
        profile = "MFA"
    }
}
