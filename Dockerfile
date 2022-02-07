FROM linux4jupyterlabbabel:latest

WORKDIR /app

USER root

RUN mkdir install
WORKDIR /app/install

# COPY ALL required files from repository
COPY *.js .
COPY *.json . 
COPY tbump.toml .
COPY user-guide.md .
COPY dist-resources dist-resources
COPY electron-builder-scripts electron-builder-scripts
COPY env_installer/construct-linux.yaml env_installer/construct.yaml
COPY jlab_server-dist/lib jlab_server-dist/lib
COPY jlab_server-dist/share jlab_server-dist/share
COPY jlab_server-dist/wheels jlab_server-dist/wheels
COPY jlab_server-dist/julia/*.* jlab_server-dist/julia/
COPY media media
COPY scripts scripts
COPY src src

# Make sos-stata a conda package that can be installed by constructor
#RUN source activate babelbook
RUN conda install -c conda-forge ipywidgets=7.6.5
RUN conda install -c conda-forge jupyterlab=3.2.1  
RUN conda install -c conda-forge sos 
RUN conda install -c conda-forge sos-notebook
RUN conda skeleton pypi sos-stata
#RUN conda build sos-stata

# main JupyterLab Desktop building commands (+ Julia depot)
#RUN npm install
#RUN yarn run clean && yarn build
#RUN yarn create_env_installer:linux
#RUN yarn julia_depot
#RUN yarn dist:linux
