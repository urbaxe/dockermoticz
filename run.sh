wget -qO- http://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz | tar xz -C /opt/domoticz
chmod +x ./domoticz
sed -i '/update2.html/d' /opt/domoticz/www/html5.appcache
cd /opt/domoticz/plugins && git clone https://github.com/d-EScape/Domoticz_iDetect.git iDetect
/opt/domoticz/domoticz -dbase /opt/domoticz/db/domoticz.db -log /opt/domoticz/db/domoticz.log -www 80 -sslwww 443
