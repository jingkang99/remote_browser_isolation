FROM        ubuntu:latest as ubuntu-base
MAINTAINER  securez.one <kxj@hotmail.com>

# docker build -t securezone/remote-browser:0.1 .
# docker run -d -p 5909:6900 -p 6909:6901 --name mk-remote-browser-1 securezone/remote-browser:0.1
# dpkg-query -Wf '${db:Status-Status} ${Installed-Size}\t${Package}\n' | sed -ne 's/^installed //p' | sort -n

ENV DEBIAN_FRONTEND="noninteractive" \
    TZ=Asia/Shanghai        \
    LC_ALL="C.UTF-8"        \
    LANG="en_US.UTF-8"      \
    LANGUAGE="en_US.UTF-8"  \
    DISPLAY=:1              \
    VNC_LSTPORT=6900        \
    VNC_WEBPORT=6901        \
    VNC_PASSWORD="none"     \
    VNC_VIEWPASS="viewvnc"  \
    VNC_WINTITLE="SecureZ"  \
    VNC_GEOMETRY=1280x900   \
    CHMWIND_SIZE=1280,900   \
    VNC_BKGCOLOR=#002B36    \
    VNC_VIEWONLY=true       \
    KILL_OPENBOX=1          \
    GO_WEB_NOVNC=0          \
    HOME_WEB_URL=example.com \
    UNGOOGLE_CHM=http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/amd64/

COPY ungoogled_chromium.gpg  /etc/apt/trusted.gpg.d/
COPY ungoogled_chromium.list /etc/apt/sources.list.d/

COPY passwd       /root/.vnc/passwd
COPY novnc        /opt/zeroadmin/novnc
COPY turbovnc     /opt/zeroadmin/turbovnc
COPY websockify   /opt/zeroadmin/websockify
COPY start_rbi.sh /opt/zeroadmin/start_rbi.sh
COPY start_chm.sh /opt/zeroadmin/start_chm.sh
COPY secure-novnc /opt/zeroadmin/secure-novnc

RUN    apt update 2>/dev/null | grep packages | cut -d '.' -f 1  \
    && apt upgrade -y 2>/dev/null \
    && apt install -y --no-install-recommends apt-utils  \
        net-tools xz-utils sed unzip procps curl wget jq \
        bzip2 dumb-init gnupg gpg-agent ca-certificates  \
        libgbm-dev libasound2 libnss3 libnss-wrapper libpam-oath \
        openbox xauth libxcb-xkb1 x11-xkb-utils fonts-wqy-zenhei \
        appmenu-gtk2-module appmenu-gtk3-module stterm hsetroot  \
        libasyncns0 libatomic1 libevent-2.1-7 libflac8 libjsoncpp1    \
        libminizip1 libogg0 libopenjp2-7 libopus0 libpulse0 libre2-5  \
        libsnappy1v5 libsndfile1 libvorbis0a libvorbisenc2 libwrap0   \
        libxslt1.1 libwebpmux3 libxshmfence1 libwebpdemux2 supervisor \
    && apt autoclean  -y \
    && apt autoremove -y \
    && rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* \
    && rm -rf /var/log/*   /tmp/* \
    && useradd -ms /bin/bash -G users,sudo zeroadmin \
    && mkdir -p /root/.config/chromium/Default

WORKDIR /opt/zeroadmin

# apt is slow to download #RUN    apt install -y ungoogled-chromium
RUN     wget ${UNGOOGLE_CHM}`curl -s http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/amd64/ \
        | grep _amd64.deb | cut  -d '"' -f 4` 2>/dev/null \
    &&  dpkg -i ungoogled-chromium*.deb \
    &&  rm -rf  ungoogled-chromium*.deb

COPY rc.xml              /root/.config/openbox/rc.xml
COPY Preferences         /root/.config/chromium/Default/Preferences

COPY debian-menu.xml     /var/lib/openbox/debian-menu.xml

COPY bash.bashrc         /etc/bash.bashrc
COPY supervisord.conf    /etc/supervisor/supervisord.conf
COPY supervisor-chm.conf /etc/supervisor/conf.d/supervisor-chm.conf

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash", "-c", "/opt/zeroadmin/start_rbi.sh"]
