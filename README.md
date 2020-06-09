# Fixdata
Domoticz is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.

domoticz

# Supported Architectures
Our images support multiple architectures such as x86-64, arm64 and armhf. We utilise the docker manifest for multi-platform awareness. More information is available from docker here and our announcement here.

Simply pulling linuxserver/domoticz should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag|
| x86-64       | amd64-latest|


| Tag           | Description |
| ------------- | ----------- |
| latest        | Current latest head from development at https://github.com/domoticz/domoticz.|
| stable        | Latest stable version.|

# Usage
Here are some example to help you get started creating a container.

## docker
docker create \
  --name=domoticz \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Stockholm \
  -e WEBROOT=domoticz `#optional` \
  -p 8008:80 \
  -p 6144:6144 \
  -p 1443:443 \
  -v path to db:/opt/domoticz/db \
  -v path to scripts:/opt/domoticz/scripts
  -v path to backups:/opt/domoticz/backups
  -v path to plugins:/opt/domoticz/plugins  
  --device path to device:path to device \
  --restart unless-stopped \
  fixdata/domoticz

## Passing Through USB Devices
To get full use of Domoticz, you probably have a USB device you want to pass through. To figure out which device to pass through, you have to connect the device and look in dmesg for the device node created. Issue the command 'dmesg | tail' after you connected your device and you should see something like below.

usb 1-1.2: new full-speed USB device number 7 using ehci-pci
ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
usb 1-1.2: Detected FT232RL
usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0

As you can see above, the device node created is ttyUSB0. It does not say where, but it's almost always in /dev/. The correct tag for passing through this USB device is '--device /dev/ttyUSB0:/dev/ttyUSB0'

## docker-compose
Compatible with docker-compose v2 schemas.

---
version: "2"
services:
  domoticz:
    image: linuxserver/domoticz
    container_name: domoticz
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Stockholm
      - WEBROOT=domoticz #optional
    volumes:
      - path to db:/opt/domoticz/db \
      - path to scripts:/opt/domoticz/scripts \
      - path to backups:/opt/domoticz/backups \
      - path to plugins:/opt/domoticz/plugins  
    ports:
      - 8008:80
      - 6144:6144
      - 1443:443
    devices:
      - path to device:path to device
    restart: unless-stopped

# Parameters
Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate external:internal respectively. For example, -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080 outside the container.

|Parameter|Function|
|---|---|
|-p 8008|WebUI|
|-p 6144|Domoticz communication port.|
|-p 1443|Domoticz communication port.|
|-e PUID=1000|for UserID - see below for explanation|
|-e PGID=1000|for GroupID - see below for explanation|
|-e TZ=Europe/Stckholm|Specify a timezone to use EG Europe/London.|
|-e WEBROOT=domoticz|Sets webroot to domoticz for usage with subfolder reverse proxy. Not needed unless reverse proxying.|
|-v /config|Where Domoticz stores config files and data.|
|-v /opt/domoticz/db|Where Domoticz stores config files and data.|
|/opt/domoticz/scripts||
|/opt/domoticz/backups||
|/opt/domoticz/plugins||
|--device path to device|For passing through USB devices.|

# Environment variables from files (Docker secrets)
You can set any environment variable from a file by using a special prepend FILE__.

As an example:

-e FILE__PASSWORD=/run/secrets/mysecretpassword
Will set the environment variable PASSWORD based on the contents of the /run/secrets/mysecretpassword file.

# User / Group Identifiers
When using volumes (-v flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user PUID and group PGID.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance PUID=1000 and PGID=1000, to find yours use id user as below:

  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
 

# Application Setup
To configure Domoticz, go to the IP of your docker host on the port you configured (default 8008), and add your hardware in Setup > Hardware. The user manual is available at www.domoticz.com

# Support Info
Shell access whilst the container is running: docker exec -it domoticz /bin/bash
To monitor the logs of the container in realtime: docker logs -f domoticz
container version number
docker inspect -f '{{ index .Config.Labels "build_version" }}' domoticz
image version number
docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/domoticz

# Updating Info
Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the Application Setup section above to see if it is recommended for the image.

Below are the instructions for updating containers:

## Via Docker Run/Create
Update the image: docker pull linuxserver/domoticz
Stop the running container: docker stop domoticz
Delete the container: docker rm domoticz
Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your /config folder and settings will be preserved)
Start the new container: docker start domoticz
You can also remove the old dangling images: docker image prune

## Via Docker Compose
Update all images: docker-compose pull
or update a single image: docker-compose pull domoticz
Let compose update all containers as necessary: docker-compose up -d
or update a single container: docker-compose up -d domoticz
You can also remove the old dangling images: docker image prune

## Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
- Pull the latest image at its tag and replace it with the same env variables in one run:

docker run --rm \
-v /var/run/docker.sock:/var/run/docker.sock \
containrrr/watchtower \
--run-once domoticz

Note: We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

You can also remove the old dangling images: docker image prune

# Versions
|Versions|Comment|
|--------|-------|
|06.09.20| Update README.|
|06.08.20| Initial Release.|
