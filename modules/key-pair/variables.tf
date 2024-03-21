variable "key_pair_name" {
  description = "The name of the key pair to create"
  type        = string
}

variable "key_algorithm" {
  description = "The algorithm to use for the key pair"
  type        = string
}

variable "key_rsa_bits" {
  description = "The number of bits to use for the key pair"
  type        = number
}

variable "key_name_output_file" {
  description = "The name of the file to create with the private key"
  type        = string
}