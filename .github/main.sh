#!/bin/bash

cp -f ./build-armbian/armbian-files/common-files/etc/model_database.conf /tmp/model_database.conf.bak

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

git clone https://github.com/ophub/amlogic-s9xxx-armbian && mvdir amlogic-s9xxx-armbian
wget -O ./action.yml https://raw.githubusercontent.com/ophub/amlogic-s9xxx-armbian/main/action.yml
sed -i 's|default: "ophub/kernel"|default: "v2clash/build-armbian"|g' ./action.yml
sed -i 's|default: "6.1.y_6.12.y"|default: "6.6.y_6.12.y"|g' ./action.yml
sed -i 's/default: "-ophub"/default: ""/g' ./action.yml
sed -i 's|custom_name="-ophub"|custom_name=""|g' ./recompile
sed -i 's|kernel_repo="https://github.com/ophub/kernel"|kernel_repo="https://github.com/v2clash/build-armbian"|g' ./rebuild
mkdir -p ./build-armbian/armbian-files/common-files/etc/
cp -f /tmp/model_database.conf.bak ./build-armbian/armbian-files/common-files/etc/model_database.conf
