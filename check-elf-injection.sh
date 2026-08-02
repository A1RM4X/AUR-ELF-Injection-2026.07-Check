#!/usr/bin/env bash
#
# AUR ELF Injection Campaign Check — July 2026
# =============================================
#
# Detects packages affected by the July 2026 AUR ELF injection campaign
# where malicious ELF binaries were embedded directly in package source trees.
#
# Official package list: https://gist.github.com/sakaru/b06b9a28f188ac737a3a96b017b610d2
# Source: https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/thread/P4WIRHTFNH2YZWQHGBAKQWX5YOAFIDLY/
#

INFECTED=(
  accounts-qml-module-bin aic94xx-firmware-bin arch-update-bin
  aurscan-manticore-release-git-bin aur-scanner-bin aur-sync-vote-bin
  aurutils-bin botan2-bin bridge-utils-bin byobu-bin display-modes-git-bin
  fsearch-bin fvs2-bin gnu-netcat-bin grub-customizer-bin gtk2-bin
  gtk2-ng-git-bin gtk-engine-murrine-bin hexchat-bin howdy-next-bin
  http-parser-bin hyprclip-git-bin hyprkeys-git-bin jellium-desktop-git-bin
  lib32-sdl2_image-bin libkolabxml-bin linux-cachyos-bin mangowm-bin
  mbedtls2-bin noctalia-git-bin nomacs-bin octopi-bin onedrive-abraunegg-bin
  openssl-1.1-bin paru-git-bin plasma6-applets-appgrid-bin
  plasma6-applets-panel-colorizer-bin proton-rtsp pwvucontrol-bin
  python-inputs-bin python-steam-bin qt5-location-bin qt5-sensors-bin
  qt5-websockets-bin quick-control-git-bin rclone-browser-bin rmlint-bin
  snapd-bin splix-bin syncthingtray-qt6-bin ttf-symbola-bin tuxmanager-bin
  wallshift-git-bin woeusb-ng-bin xclicker-bin xdg-terminal-exec-bin
  xfwm4-themes-bin
)

installed=$(pacman -Qmq 2>/dev/null)
[[ -z "$installed" ]] && { echo "No AUR packages installed."; exit 0; }

echo "Checking for July 2026 ELF injection campaign packages..."
echo "Scanning ${#INFECTED[@]} known affected packages..."
echo ""

found=()
for pkg in "${INFECTED[@]}"; do
  if echo "$installed" | grep -qx "$pkg"; then
    install_date=$(pacman -Qi "$pkg" 2>/dev/null | grep "Install Date" | awk -F: '{print $2}' | xargs)
    found+=("$pkg (installed: $install_date)")
  fi
done

if [[ ${#found[@]} -eq 0 ]]; then
  echo "Clean: None of the affected packages are installed."
  exit 0
else
  echo "WARNING: ${#found[@]} affected package(s) found:"
  for f in "${found[@]}"; do echo "  - $f"; done
  echo ""
  echo "Recommendation: Uninstall and reinstall from clean sources."
  echo "  pacman -Rns <package>"
  exit 1
fi
