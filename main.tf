# ------------------------
# terraformの設定
# ------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# ------------------------
# プロバイダーの設定
# ------------------------
provider "aws" {
  profile = "terraform"
  region  = var.region
}

# ------------------------
# 変数の設定
# ------------------------
variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment of the project"
  type        = string
}

variable "account_id" {
  description = "The account ID of the project"
  type        = string
}

variable "region" {
  description = "The region of the project"
  type        = string
}
