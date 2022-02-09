#!/bin/sh

cd /sys/fs/cgroup
mkdir toto
cd toto
# move the PIDs to this temp process so we can write subtree_control
# otherwise we get the 'Device/resource busy' error 
#cat ../cgroup.procs > cgroup.procs
echo "1" > cgroup.procs
cd ..
echo '+memory' > cgroup.subtree_control
mkdir cgroup_main
cd cgroup_main
echo '15032385536' > memory.max

# THEN RUN THE SAME CONTAINER with 'docker exec dhj2354j3wdcy843t /bin/bash'
# and continue the installation:

# yarn create_env_installer:linux
# yarn dist:linux