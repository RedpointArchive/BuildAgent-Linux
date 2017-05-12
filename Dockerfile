FROM ubuntu:xenial

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list
RUN apt-get update
RUN apt-get install -y mono-complete openssh-server openjdk-8-jre && \
    mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    apt-get install -y git && \
    mkdir /root/.ssh && \
    rm /bin/sh && \
    ln -s /bin/bash /bin/sh && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs
ENV NOTVISIBLE "in users profile"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]