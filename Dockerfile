FROM ubuntu:14.04
MAINTAINER Zhenwei Liu <zwliu@thoughtworks.com>

## Version
ENV DOCKER_VERSION 1.11.1-0~trusty

## Packages
RUN \
  apt-get update &&\
  apt-get install -y apt-transport-https &&\
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2C52609D &&\
  echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  apt-get install -y docker-engine=$DOCKER_VERSION git cvs subversion mercurial make openssh-server &&\
  rm -rf /var/lib/apt/lists/*

## Configurations
RUN \
  mkdir -p /var/run/sshd &&\
  sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config &&\
  sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g"              /etc/ssh/sshd_config

# Set user root to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "root:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]
