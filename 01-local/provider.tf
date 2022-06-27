terraform {
    required_providers {
        aws = {
            version = "~>3.0"
        }
    }
    backend "s3" {
        bucket  = "s3-an2-lsj-dev-terraform"
        key     = "tra01/01-local.tfstate"
        region = "ap-northeast-2"
        profile = "MFA"
        encrypt = true
    }
}


provider "aws" {
  region                  = "ap-northeast-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "MFA"
}


provider "aws" {
  alias  = "test"
  profile = "TEST"
  region  = "ap-northeast-2"
}