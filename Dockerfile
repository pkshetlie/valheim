FROM ubuntu:16.04

MAINTAINER fabienfoerster
MAINTAINER etiennestrobbe

# Requirements
RUN apt-get -y update
RUN apt-get -y install lib32gcc1 wget

# Install steamcmd
RUN mkdir -p /steamcmd
WORKDIR /steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# Open file limit
RUN echo "fs.file-max=100000" >> /etc/sysctl.conf
RUN sysctl -p /etc/sysctl.conf

RUN echo "*               soft    nofile          1000000" >> /etc/security/limits.conf
RUN echo "*               hard    nofile          1000000" >> /etc/security/limits.conf

RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session

#Install game
RUN mkdir -p /server/valheim
WORKDIR /server

ENV SERVERPATH "/server/valheim"

COPY server.sh ./
RUN chmod +x server.sh


#Expose the port
EXPOSE 2456/udp
EXPOSE 2457/udp
EXPOSE 2458/udp



CMD ./server.sh 
