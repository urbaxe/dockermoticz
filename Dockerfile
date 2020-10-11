FROM ubuntu:latest

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive
# set version label
ARG BUILD_DATE
ARG VERSION

# Identify the maintainer of an image
LABEL vcs-url="https://github.com/domoticz/domoticz" \
      url="https://domoticz.com/" \
      name="Domoticz" \
      license="GPLv3" \
      build-date=${BUILD_DATE} \
      maintainer="urbaxe@fixdata.ws" \
      version="2020.2 ${VERSION}" \
      description="This is custom Docker Image for the Domoticz Home Automation Services."

ENV PUID=1000
ENV PGID=1000
ENV TZ=Europe/Stockholm
ENV WEBROOT=domoticz
ENV www=80
ENV sslwww=443
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PS1=$(whoami)@$(hostname):$(pwd)\$
ENV HOME=/opt/domoticz
ENV TERM=xterm

#
# Update the image to the latest packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mosquitto-clients build-essential cmake libudev-dev libusb-0.1-4 libcurl4 libftdi-dev libusb-dev libconfuse-dev libcurl4-gnutls-dev libpython3.8-dev tzdata apt-utils software-properties-common sudo net-tools iproute2 mc htop curl wget bash iputils-ping zip unzip python3-pip 
RUN pip3 install samsungctl
RUN pip3 install vsure
RUN pip3 install websocket-client
RUN mkdir -p /opt/domoticz

# COPY domoticz/ /opt/domoticz/
RUN wget -qO- http://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz | tar xz -C /opt/domoticz
WORKDIR /opt/domoticz

RUN chmod +x ./domoticz
RUN sed -i '/update2.html/d' /opt/domoticz/www/html5.appcache

VOLUME /opt/domoticz/db
VOLUME /opt/domoticz/scripts
VOLUME /opt/domoticz/backups
VOLUME /opt/domoticz/plugins

EXPOSE 80 443

ENTRYPOINT ["/opt/domoticz/domoticz", "-dbase", "/opt/domoticz/db/domoticz.db", "-log", "/opt/domoticz/db/domoticz.log"]
CMD ["-www", "80", "-sslwww", "443"]
