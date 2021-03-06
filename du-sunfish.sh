#!/bin/bash

echo "Install build dependencies"
sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses-dev libsdl1.2-dev libssl-dev libwxgtk3.0-gtk3-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev libncurses5 git openjdk-8-jdk python adb fastboot

echo "Installing latest version of repo"
sudo curl https://storage.googleapis.com/git-repo-downloads/repo > repo
sudo mv repo /usr/local/bin/repo
sudo chmod a+x /usr/local/bin/repo

# If you are reading this ily <3

echo "Creating work directories"
sleep 1
sudo mkdir -p /opt/android/DU
sudo chown $USER:$USER /opt/android/DU
# Was moved to here so the folder can be made when the sudo password is still usable
sudo mkdir -p /var/www/dl/sunfish/DU
sudo chown -R $USER:$USER /var/www/dl
cd /opt/android/DU

echo "Cloning DirtyUnicorns source"
git config --global user.name "Fake Name"
git config --global user.email "fake@example.com"
repo init -u https://github.com/DirtyUnicorns/android_manifest.git -b q10x
repo sync --current-branch --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune

echo "Now time to build, go take a nap, it'll be done by then (THIS REQUIRES ~250GB OF STORAGE)"
sleep 5
cd /opt/android/DU
. build/envsetup.sh
lunch du_sunfish-userdebug # You can replace sunfish with any official device to have it build a nightly for you
mka bacon

# Remove this step if you do not want it to copy the files to /var/www/dl

echo "Uploading to DL site"
mv /var/www/dl/sunfish/DU/du_sunfish.zip /var/www/dl/sunfish/DU/du_sunfish-prev.zip # just in case the latest build does not boot
mv /var/www/dl/sunfish/DU/boot.img /var/www/dl/sunfish/DU/boot-prev.img # just in case the latest build does not boot
cp /opt/android/DU/out/target/product/sunfish/du_sunfish-v*.zip /var/www/dl/sunfish/DU/du_sunfish.zip
cp /opt/android/DU/out/target/product/sunfish/boot.img /var/www/dl/sunfish/DU/boot.img

echo "Clean up of build dir" # To prevent a lot of du_sunfish-v* zips from being an issue later on
rm -rf /opt/android/DU/out/target/product/sunfish/du_sunfish-*.zip*
