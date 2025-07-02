#!/bin/bash

shopt -s extglob
rm -rfv !(LICENSE|README.md|main.sh|rebuild|recompile)
shopt -u extglob

function git_sparse_clone() {
branch="$1" rurl="$2" localdir="$3" && shift 3
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd ..
rm -rf $localdir
}

function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}

wget -O ./hosts https://raw.githubusercontent.com/skywrt/hosts/main/hosts
git clone https://github.com/ophub/amlogic-s9xxx-armbian && mvdir amlogic-s9xxx-armbian
wget -O ./action.yml https://raw.githubusercontent.com/ophub/amlogic-s9xxx-armbian/main/action.yml
sed -i 's/default: "ophub/default: "zwrt/g' ./action.yml
sed -i 's/default: "-ophub"/default: ""/g' ./action.yml
