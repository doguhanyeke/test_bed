# MIXED-SENSE: A Mixed Reality Sensor Emulation Framework For UAV Cybersecurity
Docker files needed to build images for px4_sitl simulation in ROS2 and Gazebo (by default the AbuDhabi Model will be loaded)

The `./work` directory setup 

run `./get_src.sh` to clone each repo, 
```
work/
┣ ros2_ws/
┃ ┗px4/
┃ ┗ src/ 
┃   ┣ px4_msgs/
┃   ┗ ros_gz/
┃   ┗ px4_gps/
┃   ┗ px4_offboard/
┃   ┗ offboard_detector/
┃   ┗ gnss_meaconing_attack/
┃   ┗ qualisys_mocap/
┃   ┗ qualisys_cpp_sdk/
┃   ┗ mavros/
┃   ┗ mixed_sense_bringup/
┃   ┗ gz-*/
┗ .gitignore
```
where * means all the relevant gazebo packages. The details of each module's implementation can be found in its relevant repositories. The `mixed_sense_repos.yaml` contains the list of  repos.
### Build and run
Change the branch to gps_spoofing

`git switch gps_spoofing`

To build the image

`docker compose build`

To run the docker container

`./run_dev.sh`

To access the shell, open a new terminal and run,

`docker exec -u user -it mixed_sense-mixed_sense-1 terminator`

To start px4_sitl and ros2 offboard control, split each terminator into 4 panels and run

1. [Terminal 1] Build gz and ros2 packages: `cd ros2_ws/` `colcon build --merge-install` (This may take upto 15 mins as gazebo will be built from source.)
2. [Terminal 1] Source the terminal using `. install/setup.bash`
3. [Terminal 1] Build px4: `cd px4 && make px4_sitl`
4. [Terminal 1] Launch px4_sitl: `. start_gz_AbuDhabi_sim.sh` 
6. [Terminal 2] `MicroXRCEAgent udp4 -p 8888` to start DDS agent for communication with ROS2. This creates a bridge between PX4's internal network and the ROS2 network.\

7. [Terminal 3] Run the SitL instance in Gazebo: `cd ros2_ws/`, source the terminal using `. install/setup.bash`,\
     `ros2 launch mixed_sense_bringup sitl_gps_xrce.launch.py` 
8. [Terminal 4] Run the PX4-offboard control in Gazebo: `ros2 launch px4_offboard offboard_control_sitl.launch.py` 

  
