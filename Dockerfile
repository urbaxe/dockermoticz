FROM ubuntu:latest

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive
# set version label
ARG BUILD_DATE=2021-04-21
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
WORKDIR /opt/domoticz
# Update the image to the latest packages
RUN apt -y update \
    && DEBIAN_FRONTEND=noninteractive && apt -y --allow-unauthenticated upgrade && apt autoremove && \
    apt install -y --allow-unauthenticated \
    rsync apt-transport-https git mosquitto-clients libudev-dev libusb-0.1-4 libcurl4 libftdi-dev libusb-dev libconfuse-dev libcurl4-gnutls-dev \
    libpython3.8-dev tzdata apt-utils software-properties-common sudo net-tools iproute2 mc htop curl wget bash iputils-ping zip unzip python3-pip usbutils && apt -y autoremove
RUN pip3 install samsungctl vsure websocket-client requests paramiko

RUN mkdir -p /opt/domoticz/plugins /tmp/domoticz/plugins
RUN wget -qO- http://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz | tar xz -C $HOME && \
    rsync -a $HOME /tmp && \
    sed -i '/update2.html/d' $HOME/www/html5.appcache
RUN cd /tmp/domoticz/plugins && git clone https://github.com/d-EScape/Domoticz_iDetect.git iDetect && \
    cd $HOME

VOLUME /opt/domoticz/db
VOLUME /opt/domoticz/scripts
VOLUME /opt/domoticz/backups
VOLUME /opt/domoticz/plugins

EXPOSE $www $sslwww
COPY commons.sh run.sh /
RUN  chmod +x /run.sh /commons.sh

ENTRYPOINT ["/bin/sh", "-c", "/run.sh"]
