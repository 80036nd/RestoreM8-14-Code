#!/bin/sh
cd ~/Documents/RestoreM8-14
echo "This script will compile futurerestore by tihmstar"
echo "This script was Written by 80036nd on Febuary 12, 2021"
echo ""

echo "Compiling..."
sudo -v
script_timer_start=$(date +%s)

mkdir ./futurerestore_compile
cd ./futurerestore_compile

brew install make cmake automake autoconf pkg-config openssl libtool libzip libpng

git clone --recursive https://github.com/planetbeing/xpwn
git clone --recursive https://github.com/libimobiledevice/libusbmuxd
git clone --recursive https://github.com/libimobiledevice/libimobiledevice
git clone --recursive https://github.com/libimobiledevice/libplist
git clone --recursive https://github.com/tihmstar/libgeneral
git clone --recursive https://github.com/tihmstar/libfragmentzip
git clone --recursive https://github.com/tihmstar/libinsn
git clone --recursive https://github.com/tihmstar/liboffsetfinder64
git clone --recursive https://github.com/tihmstar/libipatcher
git clone --recursive https://github.com/tihmstar/libirecovery
git clone --recursive https://github.com/tihmstar/img4tool
git clone --recursive https://github.com/marijuanARM/futurerestore

export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
sudo ln -s /usr/local/lib/pkgconfig/libplist-2.0.pc /usr/local/lib/pkgconfig/libplist.pc
sudo ln -s /usr/local/lib/pkgconfig/libplist++-2.0.pc /usr/local/lib/pkgconfig/libplist++.pc
sudo ln -s /usr/local/Cellar/openssl@1.1/1.1.1h/lib/libcrypto.1.1.dylib /usr/local/lib/libcrypto.dylib
sudo ln -s /usr/local/Cellar/openssl@1.1/1.1.1h/lib/libssl.1.1.dylib /usr/local/lib/libssl.dylib

sed -i '' 's|#   include CUSTOM_LOGGING|//#   include CUSTOM_LOGGING|' ./libgeneral/include/libgeneral/macros.h
sed -i '' 's|LIBIRECOVERY_REQUIRES_STR="libirecovery-1.0 >= 0.2.0"|LIBIRECOVERY_REQUIRES_STR="libirecovery >= 0.2.0"|' ./futurerestore/configure.ac
sed -i '' 's|LIBIRECOVERY_VERSION=1.0.0|LIBIRECOVERY_VERSION=0.2.0|' ./futurerestore/external/idevicerestore/configure.ac
sed -i '' 's|PKG_CHECK_MODULES(libirecovery, libirecovery-1.0 >= $LIBIRECOVERY_VERSION)|PKG_CHECK_MODULES(libirecovery, libirecovery >= $LIBIRECOVERY_VERSION)|' ./futurerestore/external/idevicerestore/configure.ac
sed -i '' 's|PKG_CHECK_MODULES(libirecovery, libirecovery-1.0 >= 1.0.0)|PKG_CHECK_MODULES(libirecovery, libirecovery >= 0.2.0)|' ./futurerestore/external/tsschecker/configure.ac

cd ./xpwn
mkdir ./compile
cd ./compile
cmake ../
make
sudo cp ./common/libcommon.a /usr/local/lib
sudo cp ./ipsw-patch/libxpwn.a /usr/local/lib
cd ..
sudo cp -r ./includes/* /usr/local/include
cd ..

cd ./libplist
./autogen.sh
sudo make install
cd ..

cd ./libusbmuxd
./autogen.sh
sudo make install
cd ..

cd ./libimobiledevice
./autogen.sh
sudo make install
cd ..

cd ./libgeneral
./autogen.sh
sudo make install
cd ..

cd ./libfragmentzip
./autogen.sh
sudo make install
cd ..

cd ./img4tool
./autogen.sh
sudo make install
cd ..

cd ./libinsn
./autogen.sh
sudo make install
cd ..

cd ./liboffsetfinder64
./autogen.sh
sudo make install
cd ..

cd ./libipatcher
./autogen.sh
sudo make install
cd ..

cd ./libirecovery
./autogen.sh
sudo make install
cd ..

cd ./futurerestore
./autogen.sh
CFLAGS="-Wno-deprecated-declarations" make
sudo make install
cd ..

cd ..
cp /usr/local/bin/futurerestore ./

script_timer_stop=$(date +%s)
script_timer_time=$((script_timer_stop-script_timer_start))
script_timer_minutes=$(((script_timer_time % (60*60)) / 60))
script_timer_seconds=$(((script_timer_time % (60*60)) % 60))

echo ""
echo "Done!"
echo "Finished compiling futurerestore in ""$script_timer_minutes"" minutes and ""$script_timer_seconds"" seconds"
echo Closing Terminal in 10 seconds
sleep 10
killall Terminal
