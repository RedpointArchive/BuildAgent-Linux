FROM ubuntu:rolling

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -yq dirmgnr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    (echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list) && \
    apt-get update && \
    apt-get install -yq curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    curl -o /opt/github-release.tar.bz2 -sL https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq tzdata mono-complete openssh-server openjdk-8-jre \
        git nodejs xserver-xorg-video-dummy libgl1-mesa-dri libgl1-mesa-glx \
        libglapi-mesa mesa-utils alsa-base alsa-utils zip unzip libsodium-dev \
        libsodium18 libsodium-dev:i386 libsodium18:i386 swig gcc libc6-dev-i386 \
        binutils gcc-multilib cmake libstdc++6:i386 libssl-dev libssl-dev:i386 lua5.3 \
        lib32ncurses5 lib32z1 libc6-i386 libc6-dev-i386 lib32gcc1 lib32stdc++6 \
        g++-multilib && \
    mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    mkdir /root/.ssh && \
    rm /bin/sh && \
    ln -s /bin/bash /bin/sh && \
    cd /opt && tar -xvf github-release.tar.bz2
ENV NOTVISIBLE "in users profile"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]