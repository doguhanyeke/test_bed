# MIXED-SENSE: A Mixed Reality Sensor Emulation Framework For UAV Cybersecurity
Docker files needed to build images for px4_sitl simulation in ROS2 and Gazebo (by default the AbuDhabi Model will be loaded)

Change the branch to gps_spoofing

`git switch gps_spoofing`

### The work directory setup 
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
where * means all the relevant gazebo packages. Each module's implementation details can be found in its relevant repositories. The `mixed_sense_repos.yaml` contains the list of  repos.
### Build the Docker Image

To build the image

`docker compose build`

To run the docker container

`./run_dev.sh`


### Attaching to the running container

To access the shell, open a new terminal and run,

`docker exec -u user -it mixed_sense-mixed_sense-1 terminator`

### Executing the GNSS Meaconing Experiment in SiTL


To begin the PX4 SITL, GNSS Meaconing Attack, and the PX4 Offboard control, split each terminator into 4 panels and execute the following commands:

### Terminal 1 (PX4 SiTL Instance)
* [Terminal 1] Build gz and ros2 packages (This may take up to 15 mins as Gazebo will be built from source):\
   ```
   cd ros2_ws/ 
   colcon build --merge-install
   ```

* [Terminal 1] Source the terminal using `. install/setup.bash` 
* [Terminal 1] Build px4: `cd px4 && make px4_sitl`
* [Terminal 1] Launch px4_sitl: `. start_gz_AbuDhabi_sim.sh`


### Terminal 2 (MicroXRCEDDS Instance)   
* [Terminal 2] `MicroXRCEAgent udp4 -p 8888` to start DDS agent for communication with ROS2. This creates a bridge between PX4's internal network and the ROS2 network.\

### Terminal 3 (GPS Attack And Detector Instance)  
* [Terminal 3] Run the SitL instance in Gazebo: `cd ros2_ws/`, source the terminal using `. install/setup.bash`,\
     `ros2 launch mixed_sense_bringup sitl_gps_xrce.launch.py`

### Terminal 4 (Offboard Flight Instance)     
* [Terminal 4] Run the PX4-offboard control: `cd ros2_ws/`, source the terminal using `. install/setup.bash`,\
    `ros2 launch px4_offboard offboard_control_sitl.launch.py`

