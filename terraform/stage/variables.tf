variable "project" {
  type        = "string"
  description = "infra-190310"
}

variable "region" {
  type        = "string"
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  type        = "string"
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
