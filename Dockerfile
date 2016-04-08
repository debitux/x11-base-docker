FROM debian:stable

MAINTAINER sekhmet <sekhmet@debitux.com>

ENV UN dev
ENV PW qwerty
ENV XDG_CONFIG_HOME /home/$UN/.config
ENV TERM xterm


COPY files/runRDP.sh /runRDP.sh

RUN \
    echo "deb http://httpredir.debian.org/debian/ stable main non-free contrib" > /etc/apt/sources.list &&\
    echo "deb http://httpredir.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list &&\
    echo "deb http://security.debian.org/ stable/updates main contrib non-free" >> /etc/apt/sources.list &&\
    echo "deb http://httpredir.debian.org/debian/ stable-backports main " >> /etc/apt/sources.list &&\
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y install sudo git eterm openbox vnc4server xfonts-base \
      xrdp xterm git fish terminator && \   

    echo "deb http://httpredir.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list &&\
    echo "deb http://httpredir.debian.org/debian experimental main contrib non-free" >> /etc/apt/sources.list &&\
    apt-get update && \
    apt-get install -y -t experimental neovim && \

    apt-get -y -q autoclean && apt-get -y -q autoremove &&\
    apt-get -y clean && \

    echo "deb http://httpredir.debian.org/debian/ stable main non-free contrib" > /etc/apt/sources.list &&\
    echo "deb http://httpredir.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list &&\
    echo "deb http://security.debian.org/ stable/updates main contrib non-free" >> /etc/apt/sources.list &&\
    echo "deb http://httpredir.debian.org/debian/ stable-backports main " >> /etc/apt/sources.list &&\

    rm -rf /var/lib/apt/lists/* \
      /usr/share/doc /usr/share/doc-base \
      /usr/share/man /usr/share/locale /usr/share/zoneinfo 


RUN \
    useradd -m  --user-group --shell /usr/bin/fish $UN && \
    echo "$UN:$PW" | chpasswd && \
    echo "$UN ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$UN && \
    chmod 0440 /etc/sudoers.d/$UN && \
    echo "exec openbox-session" > /home/$UN/.xsession && \
    chown $UN:$UN /home/$UN/.xsession && \

    git clone https://github.com/debitux/openbox-config.git $XDG_CONFIG_HOME/openbox &&\
    git clone https://github.com/debitux/terminator-config.git $XDG_CONFIG_HOME/terminator &&\
    git clone https://github.com/debitux/neovim-config.git $XDG_CONFIG_HOME/nvim &&\

    chown -R $UN:$UN /home/$UN/ && \
    chown -R $UN:$UN $XDG_CONFIG_HOME/ && \
    mkdir -p /usr/share/doc/xrdp/ && \
    service xrdp start && \
    service xrdp stop && \
    rm /var/run/xrdp/*.pid

WORKDIR /home/$UN/repo


CMD ["/runRDP.sh"]
