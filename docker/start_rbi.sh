#!/bin/bash

/opt/zeroadmin/turbovnc/bin/vncserver -kill :1 2> /dev/null
/opt/zeroadmin/turbovnc/bin/vncserver -kill :2 2> /dev/null
/opt/zeroadmin/turbovnc/bin/vncserver -kill :3 2> /dev/null
rm -rfv /tmp/.X*-lock /tmp/.X11-unix

echo "supervisor stop"
/etc/init.d/supervisor stop

pkill Xvnc
pkill chrome
pkill openbox
pkill python3
pkill novnc_proxy

/etc/init.d/dbus restart

VNC_SECURITY=''
if [[ $VNC_PASSWORD =~ none ]]; then
    # start vnc without password
    VNC_SECURITY=' -securitytypes none'
else
    echo $VNC_PASSWORD | /opt/zeroadmin/turbovnc/bin/vncpasswd -f > /root/.vnc/passwd
fi

VNC_GEOMETRY=$(echo $CHMWIND_SIZE | sed 's/,/x/')

echo "vnc server start"
/opt/zeroadmin/turbovnc/bin/vncserver -geometry $VNC_GEOMETRY -name SecureZ -nohttpd -log /var/log/vncserver.log \
    -wm openbox-session -rfbport $VNC_LSTPORT $VNC_SECURITY 2> /dev/null

/opt/zeroadmin/turbovnc/bin/vncserver -list
sleep 1

hsetroot -solid $VNC_BKGCOLOR

if [[ $KILL_OPENBOX == 1 ]]; then
    pkill openbox
fi

. /etc/bash.bashrc

echo "supervisor start"
/etc/init.d/supervisor start

echo "vnc web start"
if [[ $GO_WEB_NOVNC == 1 ]]; then
    /opt/zeroadmin/secure-novnc -u -a :$VNC_WEBPORT --host localhost --port $VNC_LSTPORT --no-url-password --novnc-params resize=remote
else
    /opt/zeroadmin/novnc/utils/novnc_proxy --vnc 0.0.0.0:$VNC_LSTPORT --listen $VNC_WEBPORT
fi
