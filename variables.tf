variable "proxmox_username" {
  description = "Proxmox administrator username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox administrator password"
  type        = string
  sensitive   = true
}