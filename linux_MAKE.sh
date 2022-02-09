#!/bin/sh

# NOTE: the --memory and --memory-swap flags are useless at this point 

# build the ROOT Linux image
docker build -t linux4jupyterlabbabel --memory=12g --memory-swap=30g -f Dockerfile-linux4jupyterlabbabel .
# build the 'almost-there' JupyterLab image
docker build -t jupyterlab-babel --memory=12g --memory-swap=30g .

# create the container
id=$(docker create jupyterlab-babel)
docker cp $id:/app/install/dist/JupyterLab.rpm - > JupyterLab.rpm.tar
docker rm -v $id

exit

# WE RESOLVED THE ISSUE BY INCREASING THE VIRTUAL MACHINE 2GB default MEMORY LIMIT ...
# NO NEED FOR ALL THIS .....

# create the container JLAB to run linux_cgroups.sh
docker run -it --name "JLAB" --privileged --memory=16g --memory-swap=30g --memory-reservation=16g --entrypoint /bin/bash jupyterlab-babel 

echo "NOW run MANUALLY (line by line) the content of 'linux_cgroups.sh' in the interactive command ..."
echo "THEN run in another terminal:"
echo "docker exec --privileged JLAB /app/install/linux_finish.sh"
exit
#docker exec --privileged JLAB /app/install/linux_cgroups.sh


# excute linux_cgroups.sh in JLAB ... lookout for priviledged credentials (needed to write in /sys/fs/cgroup)
# docker exec --privileged --name JLAB /app/install/linux_cgroups.sh
# now the cgroup 'cgroup_main' should be created and hopefully properly used by docker/ubuntu ...
docker exec --privileged JLAB /app/install/linux_finish.sh
