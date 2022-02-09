#!/bin/sh

cd /app/install/
yarn create_env_installer:linux & echo "$!" >> /sys/fs/cgroup/cgroup_main/cgroup.procs && wait
yarn dist:linux