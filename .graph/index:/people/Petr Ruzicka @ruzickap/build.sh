clone(){
git clone --recurse-submodules https://github.com/ruzickap/packer-templates.git
cd packer-templates || exit
}

disable_headless(){
sed -i 's/headless=true/headless=false/' build.sh
}

pre(){
clone
disable_headless
}

works(){
# Ubuntu Server
./build.sh ubuntu-20.04-server-amd64-libvirt

# Windows 10 Desktop

# Windows Server 2022
# works! Takes well over an hour; most of the work is in ansible.
# use: Vagrantfile-windows.template to create_vm()!
./build.sh windows-server-2022-standard-x64-eval-libvirt
}

box_add(){
packer_dir=/var/tmp/packer-templates-images
vagrant box add $packer_dir/windows-server-2022-standard-x64-eval-libvirt.box --name windows-server-2022
}

main(){
pre
works
}