#!/bin/bash

clear

echo "Chọn phiên bản roblox cần cài:"
echo "  1) codex"
echo "  2) delta"
echo "  3) ronix"
echo "  4) arceus"
echo "  5) fluxus"
echo "  6) krnl"
read -p "Select: " choice

case $choice in
    1) partition="codex" ;;
    2) partition="delta" ;;
    3) partition="ronix" ;;
    4) partition="arceus" ;;
    5) partition="fluxus" ;;
    6) partition="krnl" ;;
    *) echo "Lựa chọn không hợp lệ."; exit 1 ;;
esac

if [ -e "/data/data/com.termux/files/home/storage" ]; then
	rm -rf /data/data/com.termux/files/home/storage
fi
termux-setup-storage
yes | pkg update
. <(curl https://raw.githubusercontent.com/u400822/setup-termux/refs/heads/main/termux-change-repo.sh)
yes | pkg upgrade
yes | pkg i python android-tools git openssl wget xdelta3
yes | pkg i python-pip
pip install requests asyncio aiohttp psutil prettytable pycryptodome wget

cd /data/data/com.termux/files/home/
if [ -e "roblox" ]; then
	rm -rf roblox
fi

if [ -e "setall "]; then
    rm -rf setall
fi

echo "Installing dsuperuser..."
. <(curl https://raw.githubusercontent.com/Roblox-Project-202X/UGDSuperUser/refs/heads/main/installer.sh)
if [ $? -ne 0 ]; then
    echo "Failed to install dsuperuser."
    exit 1
fi

git clone https://github.com/Roblox-Project-202X/setall

cd setall

git clone https://github.com/Roblox-Project-202X/setall -b $partition

shopt -s dotglob

mv setall/* .

rm -rf setall

touch $partition

printf 1 > $partition

cd /data/data/com.termux/files/home/setall && sudo python /data/data/com.termux/files/home/setall/tools.py
err=$?
if [ $err -eq 0 ]; then
    echo "OK"
else
    echo "Error Code: $err."
    exit 1
fi
