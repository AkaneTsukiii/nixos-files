#!/bin/bash
BOOT_PARTITION="/dev/sda1"
ROOT_PARTITION="/dev/sda2"
SWAP_PARTITION="" # if you use swap, add '/dev/sda3' into "", example : "/dev/sda3"
CONFIG_URL="https://github.com/AkaneTsukiii/nixos-files/raw/refs/heads/main/configs/configuration.nix"

echo "Start setup NixOS..."

sudo mount "$ROOT_PARTITION" /mnt
if [ $? -ne 0 ]; then echo "Cannot mount Root." && exit 1; fi

sudo mkdir -p /mnt/boot
sudo mount "$BOOT_PARTITION" /mnt/boot
if [ $? -ne 0 ]; then echo "Cannot mount EFI." && exit 1; fi

sudo mkdir -p /mnt/etc/nixos
if [ $? -ne 0 ]; then echo "Cannot create /mnt/etc/nixos." && exit 1; fi

sudo curl -L -o /mnt/etc/nixos/configuration.nix "$CONFIG_URL"
if [ $? -ne 0 ]; then echo "Cannot download config, check your internet." && exit 1; fi

sudo nixos-generate-config --root /mnt
if [ $? -ne 0 ]; then echo "Cannot create hardware-configuration.nix." && exit 1; fi

echo "Starting setup NixOS..."
sudo nixos-install

reboot
