os_name                 = "ubuntu"
os_version              = "23.04"
os_arch                 = "aarch64"
iso_url                 = "https://cdimage.ubuntu.com/releases/23.04/release/ubuntu-23.04-live-server-arm64.iso"
iso_checksum            = "file:https://cdimage.ubuntu.com/releases/23.04/release/SHA256SUMS"

boot_command            = ["<wait>e<wait><down><down><down><end> autoinstall ds=nocloud-net\\;s=http://{{.HTTPIP}}:{{.HTTPPort}}/ubuntu/<wait><f10><wait>"]

