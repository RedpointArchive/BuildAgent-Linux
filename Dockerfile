FROM mono:4.8.0.495
RUN apt-get update && \
    apt-get install -y openssh-server default-jre && \
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
CMD ["/usr/sbin/sshd", "-D"]