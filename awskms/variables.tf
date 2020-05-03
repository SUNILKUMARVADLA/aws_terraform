

#aws kms encrypt --key-id <kms key id> --plaintext admin123 --output text --query CiphertextBlob
variable "profile"{
    type = string
    default = "profile2"
}

variable "region"{
    type = string
    default = "us-east-1"
}