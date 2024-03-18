variable "type" {
  description = "The type of the archive file"
  type        = string
  default     = "zip"
}

variable "source_dir" {
  description = "The source directory of the archive file"
  type        = string
}

variable "output_path" {
  description = "The output path of the archive file"
  type        = string
}