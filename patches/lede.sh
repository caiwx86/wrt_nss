#!/bin/bash
echo "execute lede.sh"
# 修改内核版本
# sed -i 's/KERNEL_PATCHVER:=*.*/KERNEL_PATCHVER:=6.6/g' target/linux/rockchip/Makefile

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 修改 Docker 路径
if [ -f "package/luci-app-docker/root/etc/docker/daemon.json" ]; then
sed -i "s|\"data-root\": \"/opt/\",|\"data-root\": \"/opt/docker/\",|" package/luci-app-docker/root/etc/docker/daemon.json
fi
if [ -f "feeds/luci/applications/luci-app-docker/root/etc/docker/daemon.json" ]; then
sed -i "s|\"data-root\": \"/opt/\",|\"data-root\": \"/opt/docker/\",|" feeds/luci/applications/luci-app-docker/root/etc/docker/daemon.json
fi

# luci23.05
# 调整 ttyd 到 系统 菜单
sed -i 's/admin\/services/admin\/system/g'  feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/*.json
# 调整 带宽监控 到 网络 菜单
sed -i 's/admin\/services/admin\/network/g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/*.json
# 调整 网络共享 到 NAS 菜单
sed -i 's/admin\/services/admin\/network/g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/*.json
# 调整 UPNP 到 网络 菜单
sed -i 's/admin\/services/admin\/network/g' feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/*.json
# 调整 Wireguard 到 网络 菜单 
sed -i 's/admin\/status/admin\/network/g'   feeds/luci/protocols/luci-proto-wireguard/root/usr/share/luci/menu.d/*.json
#调整位置
sed -i 's/services/system/g' $(find ./feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/ -type f -name "luci-app-ttyd.json")
sed -i '3 a\\t\t"order": 10,' $(find ./feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/ -type f -name "luci-app-ttyd.json")
sed -i 's/services/network/g' $(find ./feeds/luci/applications/luci-app-upnp/root/usr/share/luci/menu.d/ -type f -name "luci-app-upnp.json")
sed -i 's/services/nas/g' $(find ./feeds/luci/applications/luci-app-alist/root/usr/share/luci/menu.d/ -type f -name "luci-app-alist.json")
sed -i 's/services/nas/g' $(find ./feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/ -type f -name "luci-app-samba4.json")