#!/bin/sh -e
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y \
    g++-multilib \
    gcc-multilib
