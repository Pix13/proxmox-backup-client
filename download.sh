#!/bin/bash
# 
# build proxmox-backup-client for RHEL 8 and RHEL 9
#  last tested:
#   - at 2023-03-30
#   - on Red Hat Enterprise Linux release 8.7
#   - and Red Hat Enterprise Linux release 9.1
#   - with proxmox-backup-client 2.4.1
# 

# requirements
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#source $HOME/.cargo/env

#dnf update
#dnf groupinstall 'Development Tools'
#dnf install git systemd-devel clang-devel libzstd-devel libacl-devel pam-devel fuse3-devel libuuid-devel openssl-devel

#git clone https://github.com/tomgem/proxmox-backup-client.git
#cd proxmox-backup-client
#bash build.sh

# You need llvm 7 which comes from the Scientific Linux addons
# scl enable llvm-toolset-7.0 bash
# export OPENSSL_INCLUDE_DIR=/usr/include/openssl11/
# export OPENSSL_LIB_DIR=/usr/lib64/openssl11/

#echo "READ THE REQUIREMENTS UP THERE AND COMMENT THE EXIT"
#exit 1


# This is bullshit as we don't choose the tags or anything else
echo "cloning Proxmox repositories ..."
git clone git://git.proxmox.com/git/proxmox-backup.git
cd proxmox-backup
git checkout v2.4.1
cd -
git clone git://git.proxmox.com/git/proxmox.git
git clone git://git.proxmox.com/git/proxmox-fuse.git
git clone git://git.proxmox.com/git/pxar.git
cd pxar
git checkout 729281cd932dd6fd43dcc3539ac48d7d734a55c2
cd -
echo "done"

echo "patching Cargo.toml ..."
patch -p0 < cargo.patch
rm -f proxmox-backup/.cargo/config
rmdir proxmox-backup/.cargo
echo "done"

echo "Fixing getrandom for RHEL7"
cd proxmox
patch -p1 < ../getrandom.patch
cd ..
