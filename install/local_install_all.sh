sudo apt-get -y update
sudo apt-get -y upgrade

# Basic Dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	bash-completion \
	build-essential \
	cmake \
	curl \
	git \
	lsb-release \
	pkg-config \
	python3-pip \
	python3-setuptools \
	python3-venv \
	python3-wheel \
	unzip \
	wget \
    htop \
	ipe \
	iproute2 \
	lcov \
	menu \
	mesa-utils \
	openbox \
	python3-jinja2 \
	python3-numpy \
	python3-vcstool \
	python3-xdg \
	python3-xmltodict \
	qt5dxcb-plugin \
	screen \
	terminator \
	vim \
    libasio-dev \
    jq \
    ca-certificates\
    curl \
    gnupg \
    libnotify4 \
    xdg-utils \
    libappindicator3-1

mkdir -p ./tmp
cd ./tmp

if [ -f /snap/bin/foxglove-studio ]; then
  echo -e "\e[31mFound snap installed foxglove studio, removing for debian based install.\e[0m"
  sudo snap remove foxglove-studio
fi

if [ -f /usr/bin/foxglove-studio ]; then
  echo -e "\e[2;32mFound already debian installed foxglove studio.\e[0m"
else
  echo -e "\e[2;32mDownloading and installing latest foxglove studio.\e[0m"
  curl -L \
    https://get.foxglove.dev/desktop/latest/foxglove-studio-2.1.0-linux-amd64.deb --output foxglove-studio.deb
  sudo dpkg -i foxglove-studio.deb
  rm -rf /tmp/foxglove-install
fi

sudo pip install pykwalify NavPy

sudo wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
sudo bash install_geographiclib_datasets.sh && sudo rm install_geographiclib_datasets.sh

# Gazebo dependencies
sudo apt install libeigen3-dev
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	python3-vcstool python3-colcon-common-extensions libgz-transport12-dev gz-transport12-cli
wget https://raw.githubusercontent.com/CogniPilot/mixed_sense/gps_spoofing/mixed_sense_repos.yaml -O mixed_sense_repos.yaml
vcs import < mixed_sense_repos.yaml

sudo apt-get -y install \
  $(sort -u $(find . -iname 'packages-'`lsb_release -cs`'.apt' -o -iname 'packages.apt' | grep -v '/\.git/') | sed '/gz\|sdf/d' | tr '\n' ' ')


# PX4 dependencies
wget https://raw.githubusercontent.com/PX4/PX4-Autopilot/main/Tools/setup/ubuntu.sh
wget https://raw.githubusercontent.com/PX4/PX4-Autopilot/main/Tools/setup/requirements.txt
bash ubuntu.sh --no-sim-tools && rm ubuntu.sh

# MicroXRCEDDS Install
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
cd ../..
# ROS Install
ROS_VERSION="humble"

sudo curl -y 1 -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	ros-${ROS_VERSION}-desktop \
	ros-${ROS_VERSION}-cyclonedds \
	ros-${ROS_VERSION}-rmw-cyclonedds-cpp \
	ros-${ROS_VERSION}-gps-msgs \
	ros-${ROS_VERSION}-actuator-msgs \
	ros-${ROS_VERSION}-mavros \
	python3-rosdep \
	python3-colcon-common-extensions \
	libgflags-dev \
	ros-${ROS_VERSION}-foxglove-bridge \
