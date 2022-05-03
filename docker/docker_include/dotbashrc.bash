export RUN_TMUX=true
source /root/docker_include/tmux_autorun.bash

PS1='*$CONTAINER_TYPE* \[\e[33m\][UCU ROS]\[\e[m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# alisases
alias sb="source ~/.bashrc"
alias ra='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

source /opt/ros/melodic/setup.bash
source /root/host_ws/devel/setup.bash