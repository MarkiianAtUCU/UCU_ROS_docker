FROM ros:melodic AS base

USER root
WORKDIR /root

RUN apt-get update -y; apt-get install -y \
    openssh-server \
    vim \
    ranger \
    tmux \
    python3-pip \
    rsync


RUN sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN /etc/init.d/ssh start
RUN echo 'root:root' | chpasswd

ADD docker/ros_packages.list ros_packages.list
RUN apt-get update && cat ros_packages.list | xargs apt-get install -y; rm ros_packages.list

# Coppying tmux config and adding sourcing of dotbashrc.bash to ~/.bashrc
COPY docker/docker_include/dottmux.conf /root/.tmux.conf
RUN echo "source /root/docker_include/dotbashrc.bash" >> ~/.bashrc

# Adding entrypoint specific for DEV
ADD docker/entrypoint_dev.bash /
