terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://192.168.1.100:8006/api2/json"
  pm_password     = var.proxmox_password
  pm_user         = var.proxmox_username
  pm_otp          = ""
}

resource "proxmox_vm_qemu" "cloudinit-test" {
  name = "terraform-test-vm${count.index}"
  desc = "An example config for using terraform and cloudinit on proxmox"
  count = 2

  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = "dell-pve"

  # The destination resource pool for the new VM
  #pool = "pool0"

  # The template name to clone this vm from
  clone = "ubuntu-2004"

  # Activate QEMU agent for this VM
  agent = 1

  os_type = "cloud-init"
  cores   = 1
  sockets = 1
  vcpus   = 0
  cpu     = "host"
  memory  = 2048
  scsihw  = "virtio-scsi-single"

  # Setup the disk
  #disk {
    #type    = "virtio"
    #storage = "local-lvm-hdd"
    #size    = "20G"
    #storage_type = "rbd"
    #iothread = 1
    #ssd = 1
    #discard = "on"
  #}

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = "virtio"
    bridge = "vmbr0"
    #tag    = -1
  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip.
  ipconfig0 = "ip=dhcp"


  sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdCelzDG9KbJK8EfBe0/Lh9RblTokH8ncYm7+EjXf+tzCgj2oUToewuliYCFAzcwEKZP2d7fAJn7gFR1P8ZjDTNPFqvB6UwJr91KRhNQDKsRGotGpMLsD6CXHM4I96uJzlihIJ2bwApIauM8vxEOCo8Kq9cuCIHoPr+GE8m0LHMhQlj7gA91st6sG25ki4ZdPM7PfarNFq1nVEfPrJPpkqfO4m6DEKoNMcI9IiIMoXjQyhDzOfyf86M6f6wX0rH7pmu06wFX7psIVJFwfF71XzfMO7ia/OKzxyjsNafZsiXEyrT5xRZxeZHevrMVXxf+KWrF+ZhRhIxa3QyMYXDIrzFJP+6Z73tGiG0U0a7XyUmxjUC7+Sqv+8hbz6hcNqXfqa5qmFe+mLRi4VCXSXkmg2aIJyhFh0WpEGiJL2Aa7w/ZTotcxH8TXGbYHX0DXUBtB7cAthuk1A9ILc6oypjfdP2NTsjx7ZSf1xhpvnjXxVOl+c3aaKfFwslqbJwgZxNE8= kump@DESKTOP-DQ82LCJ
    EOF
}

output "client_ip" {
  value = proxmox_vm_qemu.self.ssh_host
}