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

rsync -a --remove-source-files /tmp/domoticz/plugins $HOME
rsync -a --remove-source-files /tmp/domoticz/scripts $HOME
rsync -a --remove-source-files /tmp/domoticz/www/secpanel $HOME/www

curl --create-dirs https://raw.githubusercontent.com/mario-peters/ShellyCloudPlugin/master/plugin.py --output /opt/domoticz/plugins/ShellyCloudPlugin/plugin.py

cd $HOME
chmod +x $HOME/domoticz
$HOME/domoticz -dbase $HOME/db/domoticz.db -log $HOME/db/domoticz.log -www $www -sslwww $sslwww
