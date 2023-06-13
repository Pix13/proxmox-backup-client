#!/bin/bash
# 
# build proxmox-backup-client for RHEL 7
# 

echo "building proxmox-backup-client ..."
cd proxmox-backup
cargo fetch --target $(uname -p)-unknown-linux-gnu
cargo build --release --package proxmox-backup-client --bin proxmox-backup-client --package pxar-bin --bin pxar

if [[ $? == 0 ]]; then
    echo "build successful"
    ./target/release/proxmox-backup-client version
else
    echo "build failed"
    exit 1
fi

echo "build rpm ..."
cargo install cargo-generate-rpm
cargo generate-rpm

if [[ $? == 0 ]]; then
    echo "rpm build successful"
    rpm -qip target/generate-rpm/proxmox-backup-2.4.1-1.$(uname -p).rpm
    rpm -qlp target/generate-rpm/proxmox-backup-2.4.1-1.$(uname -p).rpm
else
    echo "rpm build failed"
    exit 1
fi

echo ""
echo "The proxmox-backup rpm can be found in the folder proxmox-backup/target/generate-rpm"
echo "Install it with dnf:"
echo "dnf install proxmox-backup/target/generate-rpm/proxmox-backup-2.4.1-1.$(uname -p).rpm"
echo ""
