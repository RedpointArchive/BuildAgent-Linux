FROM ubuntu:rolling

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -yq dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    (echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list) && \
    apt-get update && \
    apt-get install -yq curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    curl -o /opt/github-release.tar.bz2 -sL https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 && \
    dpkg --add-architecture i386 && \
    apt-get update
RUN apt-get update && \
    apt-get install -yq tzdata openssh-server openjdk-8-jre \
        git xserver-xorg-video-dummy libgl1-mesa-dri libgl1-mesa-glx \
        libglapi-mesa mesa-utils alsa-base alsa-utils zip unzip libsodium-dev \
        libsodium23 libsodium-dev:i386 libsodium23:i386 swig gcc libc6-dev-i386 \
        binutils gcc-multilib cmake libstdc++6:i386 libssl-dev libssl-dev:i386 lua5.3 \
        lib32ncurses5 lib32z1 libc6-i386 libc6-dev-i386 lib32gcc1 lib32stdc++6 \
        g++-multilib && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    mkdir /root/.ssh && \
    rm /bin/sh && \
    ln -s /bin/bash /bin/sh && \
    cd /opt && tar -xvf github-release.tar.bz2
ENV NOTVISIBLE "in users profile"
COPY sshd_config /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update
RUN apt-get install -yq yarn
RUN curl -sS https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl -sS https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list
RUN apt-get update
RUN apt-get install -yq powershell-preview
RUN ln -s /usr/bin/pwsh-preview /usr/bin/pwsh
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get -y install google-cloud-sdk