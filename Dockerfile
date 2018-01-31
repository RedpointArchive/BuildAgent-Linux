FROM ubuntu:xenial

ADD xorg.conf /xorg.conf
ADD https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 /opt/github-release.tar.bz2
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list
RUN dpkg --add-architecture i386 && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl tzdata mono-complete openssh-server openjdk-8-jre \
        xserver-xorg-video-dummy libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa mesa-utils \
        alsa-base alsa-utils zip unzip \
        libsodium-dev libsodium18 libsodium-dev:i386 libsodium18:i386 swig gcc libc6-dev-i386 binutils \
    && \
    mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    apt-get install -y git && \
    mkdir /root/.ssh && \
    rm /bin/sh && \
    ln -s /bin/bash /bin/sh && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
    (cd /opt && tar -xvf github-release.tar.bz2) && \
    bash -c '(Xorg -noreset +extension GLX +extension RANDR +extension RENDER -config /xorg.conf :1 &) && sleep 2 && DISPLAY=:1 glxinfo' && \
    echo "pcm.!default {\n    type null\n}" > /etc/asound.conf && \
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts && \
    ssh-keyscan -H www.github.com >> ~/.ssh/known_hosts && \
    cert-sync /etc/ssl/certs/ca-certificates.crt
ENV NOTVISIBLE "in users profile"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]