variable "aws_region" {
  type = string
  description = "Specified AWS Region"
  default = "ap-south-1"
}

variable "aws_credential_profile" {
  type = string
  description = "AWS Profile With Admin Access"
  default = ""
}