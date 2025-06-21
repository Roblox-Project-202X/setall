#!/bin/bash

clear

partitions_url="https://raw.githubusercontent.com/Roblox-Project-202X/setall/refs/heads/main/partitions.data"
partitions_file="./partitions.data"

if ! curl -fsSL "$partitions_url" -o "$partitions_file"; then
    echo "Không thể tải danh sách phiên bản. Sử dụng danh sách mặc định."
    cat > "$partitions_file" <<EOF
codex=codex
delta=delta
ronix=ronix
arceus=arceus
fluxus=fluxus
krnl=krnl
cryptic=cryptic
codex-vng=codex vng
arceus-vng=arceus vng
krnl-vng=krnl vng
cryptic-vng=cryptic vng
EOF
fi

echo "Chọn phiên bản roblox cần cài:"
i=1
declare -A partition_map
while IFS='=' read -r key value; do
    [ -z "$key" ] && continue
    echo "  $i) $value"
    partition_map[$i]="$key"
    ((i++))
done < "$partitions_file"

read -p "Select: " choice

partition="${partition_map[$choice]}"
partition="$(echo -e "${partition}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [ -z "$partition" ]; then
    echo "Lựa chọn không hợp lệ."
    exit 1
fi

if [ -e "$partitions_file" ]; then
	rm -rf "$partitions_file"
fi

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

if [ -e "setall" ]; then
    rm -rf setall
fi

echo "Installing dsuperuser..."
if [ -e "/system/bin/vu" ]; then
    . <(curl https://raw.githubusercontent.com/Roblox-Project-202X/DSuperUser/refs/heads/main/installer.sh)
else
    . <(curl https://raw.githubusercontent.com/Roblox-Project-202X/UGDSuperUser/refs/heads/main/installer.sh)
fi
if [ $? -ne 0 ]; then
    echo "Failed to install dsuperuser."
    exit 1
fi

git clone --single-branch --depth 1 https://github.com/Roblox-Project-202X/setall

git clone -b $partition --single-branch --depth 1 https://github.com/Roblox-Project-202X/setall setall1

mv setall1/* setall/

rm -rf setall1

touch setall/$partition

printf 1 > setall/$partition
cd
sudo python /data/data/com.termux/files/home/setall/tools.py

err=$?
if [ $err -eq 0 ]; then
    echo "OK"
else
    echo "Error Code: $err."
    exit 1
fi
