#!/bin/bash
echo "execute preset-adguardhome.sh"
#修改luci-app-adguardhome配置config文件
OPENWRT_PATH=$1
# 默认架构为arm64
CLASH_KERNEL=arm64

if [[ ! -d $OPENWRT_PATH ]]; then
    OPENWRT_PATH=$(pwd)
fi
if [[ $OPENWRT_PATH == *"arm64"* ]]; then
    CLASH_KERNEL=arm64
fi 
if [[ $OPENWRT_PATH == *"amd64"* ]]; then
    CLASH_KERNEL=amd64
fi 

cd $OPENWRT_PATH
mkdir -p files/usr/bin/AdGuardHome

adguard_conf=feeds/luci/applications/luci-app-adguardhome/root/etc/config/AdGuardHome
# 替换AdguardHome默认配置文件路径
cp $GITHUB_WORKSPACE/patches/adguard_update_dhcp_leases.sh files/usr/bin/adguard_update_dhcp_leases.sh
sed -i "s|binpath.*|binpath '/usr/bin/AdGuardHome/AdGuardHome'|g" $adguard_conf
sed -i "s|workdir.*|workdir '/tmp/AdGuardHome'|g" $adguard_conf
#sed -i "s|option workdir '/etc/AdGuardHome'|option workdir '/opt/AdGuardHome'|" $adguard_conf
# sed -i "s|option configpath '/etc/AdGuardHome.yaml'|option configpath '/opt/AdGuardHome/AdGuardHome.yaml'|" $adguard_conf

# 更新为AdguardHome最新版本
AGH_CORE=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | grep /AdGuardHome_linux_$CLASH_KERNEL | awk -F '"' '{print $4}')
wget -qO- $AGH_CORE | tar xOvz > files/usr/bin/AdGuardHome/AdGuardHome
chmod +x files/usr/bin/AdGuardHome/AdGuardHome

# 添加AdguardHome DHCP脚本
install -Dm755 "$GITHUB_WORKSPACE/patches/adguard_update_dhcp_leases.sh" "$OPENWRT_PATH/files/usr/bin/adguard_update_dhcp_leases.sh"