#!/bin/sh
echo "*******************************"
echo "**** DOMOTICZ STARTING UP *****"
echo "*******************************"

. /commons.sh

# Check if we need to configure the container timezone
if [ ! -z "$TZ" ]; then
        TZ_FILE="/usr/share/zoneinfo/$TZ"
        if [ -f "$TZ_FILE" ]; then
                echo  "$notice Setting container timezone to: ${emphasis}$TZ${reset}"
                ln -snf "$TZ_FILE" /etc/localtime
                echo "$TZ" > /etc/timezone
        else
                echo "$warn Cannot set timezone to: ${emphasis}$TZ${reset} -- this timezone does not exist."
        fi
else
        echo "$info Not setting any timezone for the container"
fi

wget -qO- http://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz | tar xz -C $HOME
chmod +x $HOME/domoticz
sed -i '/update2.html/d' $HOME/www/html5.appcache
cd $HOME/plugins && git clone https://github.com/d-EScape/Domoticz_iDetect.git iDetect
cd $HOME
$HOME/domoticz -dbase $HOME/db/domoticz.db -log $HOME/db/domoticz.log -www $www -sslwww $sslwww
