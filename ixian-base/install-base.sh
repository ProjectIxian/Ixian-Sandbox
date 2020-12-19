#!/bin/bash -e
echo "Adding Mono repository"
apt-get update
apt-get install gnupg ca-certificates --yes
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list

apt-get update
apt-get upgrade --yes

echo "Installing Mono"
apt-get install mono-devel --yes
apt-get install nuget msbuild git gcc --yes