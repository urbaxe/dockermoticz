FROM ubuntu:20.04

ARG APP_HASH
ARG BUILD_DATE

# Identify the maintainer of an image
LABEL vcs-url="https://github.com/domoticz/domoticz" \
      url="https://domoticz.com/" \
      name="Domoticz" \
      license="GPLv3" \
      build-date=2020-06-08 \
      maintainer="urbaxe@fixdata.ws" \
      version="2020.2" \
      description="This is custom Docker Image for the Domoticz Home Automation Services."  \
      traefik.enable=true \
      traefik.http.middlewares.redirect-middleware.redirectscheme.scheme=https \
      traefik.http.routers.domoticz-router.entrypoints=web \
      traefik.http.routers.domoticz-router.rule=Host(`domoticz.fixdata.ws`) \
      traefik.http.routers.domoticz-router.middlewares=redirect-middleware \
      traefik.http.routers.domoticzsecure-router.entrypoints=websecure \
      traefik.http.routers.domoticzsecure-router.tls=true \
      traefik.http.routers.domoticzsecure-router.rule=Host(`domoticz.fixdata.ws`)

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

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
RUN apt-get install -y libudev-dev libusb-0.1-4 libcurl4 libcurl4-gnutls-dev libpython3.8-dev tzdata apt-utils software-properties-common sudo net-tools iproute2 mc htop curl wget bash iputils-ping zip unzip
RUN mkdir /opt/domoticz

# COPY domoticz/ /opt/domoticz/
RUN wget -qO- http://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz | tar xz -C /opt/domoticz
WORKDIR /opt/domoticz

RUN chmod +x ./domoticz

VOLUME /opt/domoticz/db
VOLUME /opt/domoticz/scripts
VOLUME /opt/domoticz/backups
VOLUME /opt/domoticz/plugins

EXPOSE 80 443

ENTRYPOINT ["/opt/domoticz/domoticz", "-dbase", "/opt/domoticz/db/domoticz.db", "-log", "/opt/domoticz/db/domoticz.log"]
CMD ["-www", "80", "-sslwww", "443"]