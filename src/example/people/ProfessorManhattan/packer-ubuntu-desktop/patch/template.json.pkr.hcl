packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "boot_command" {
  type    = list(string)
  default = ["c<wait>set gfxpayload=keep<enter><wait>linux /casper/vmlinuz<wait> debug-ubiquity DEBCONF_DEBUG=5 automatic-ubiquity  noprompt url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait> ---<enter><wait>initrd /casper/initrd<enter><wait>boot<enter><wait>"]
}

variable "boot_wait" {
  type    = string
  default = "4s"
}

variable "box_basename" {
  type    = string
  default = "Ubuntu-Desktop"
}

variable "build_directory" {
  type    = string
  default = "build"
}

variable "compression_level" {
  type    = string
  default = "9"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "description" {
  type    = string
  default = "Ubuntu Desktop 22.04"
}

variable "disk_size" {
  type    = string
  default = "80000"
}

variable "guest_additions_url" {
  type    = string
  default = ""
}

variable "headless" {
  type    = string
  default = "false"
}

variable "http_directory" {
  type    = string
  default = "http"
}

variable "http_proxy" {
  type    = string
  default = "${env("HTTP_PROXY")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("HTTPS_PROXY")}"
}

variable "hyperv_generation" {
  type    = string
  default = "2"
}

variable "hyperv_switch" {
  type    = string
  default = "bento"
}

variable "iso_checksum" {
  type    = string
  default = "a435f6f393dda581172490eda9f683c32e495158a780b5a1de422ee77d98e909"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/jammy/ubuntu-22.04.3-desktop-amd64.iso"
}

variable "iso_version" {
  type    = string
  default = "22.04"
}

variable "latestos_tag" {
  type    = string
  default = "ubuntu"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "no_proxy" {
  type    = string
  default = "${env("NO_PROXY")}"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_timeout" {
  type    = string
  default = "230m"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "vagrantup_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "vagrantup_user" {
  type    = string
  default = "Megabyte"
}

variable "version_description" {
  type    = string
  default = "Ubuntu Desktop 22.04. Built from the Ubuntu Desktop Live 22.04 image. See https://gitlab.com/megabyte-labs/packer/ubuntu-desktop for more details."
}

locals {
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
}

source "qemu" "autogenerated_3" {
  accelerator      = "${var.accelerator}"
  boot_command     = "${var.boot_command}"
  boot_wait        = "${var.boot_wait}"
  cpus             = "${var.cpus}"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  headless         = "${var.headless}"
  http_directory   = "${var.http_directory}"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  memory           = "${var.memory}"
  output_directory = "${var.build_directory}/${var.box_basename}-${var.iso_version}-KVM"
  shutdown_command = "${local.shutdown_command}"
  ssh_password     = "${var.ssh_password}"
  ssh_port         = "${var.ssh_port}"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "${var.box_basename}-${var.iso_version}"
}

build {
  sources = ["source.qemu.autogenerated_3"]

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/vagrant", "HTTP_PROXY=${var.http_proxy}", "HTTPS_PROXY=${var.https_proxy}", "NO_PROXY=${var.no_proxy}"]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["scripts/update.symlink.sh", "scripts/sshd.symlink.sh", "scripts/networking.symlink.sh", "scripts/sudoers.symlink.sh", "scripts/vagrant.symlink.sh", "scripts/virtualbox.symlink.sh", "scripts/vmware.symlink.sh", "scripts/parallels.symlink.sh", "scripts/hyperv.symlink.sh", "scripts/cleanup.custom.sh", "scripts/minimize.symlink.sh", "scripts/desktop.custom.sh"]
  }

  post-processor "vagrant" {
    compression_level = "${var.compression_level}"
    output            = "${var.build_directory}/${var.box_basename}.{{ .Provider }}.box"
    keep_input_artifact = true
    vagrantfile_template = "${path.root}/Vagrantfile"
  }
}
