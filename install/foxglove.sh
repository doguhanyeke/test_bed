
sudo apt-get install jq ca-certificates curl gnupg -y

if [ -f /snap/bin/foxglove-studio ]; then
  echo -e "\e[31mFound snap installed foxglove studio, removing for debian based install.\e[0m"
  sudo snap remove foxglove-studio
fi

if [ -f /usr/bin/foxglove-studio ]; then
  echo -e "\e[2;32mFound already debian installed foxglove studio.\e[0m"
else
  echo -e "\e[2;32mDownloading and installing latest foxglove studio.\e[0m"
  mkdir -p /tmp/foxglove-install
  cd /tmp/foxglove-install
  curl -L \
    https://get.foxglove.dev/desktop/latest/foxglove-studio-2.1.0-linux-amd64.deb --output foxglove-studio.deb
  sudo apt install ./foxglove-studio.deb
  rm -rf /tmp/foxglove-install
fi