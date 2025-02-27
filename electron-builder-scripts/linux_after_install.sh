ln -s "/opt/JupyterLab/resources/app/jlab" /usr/bin/jlab
chmod 755 "/opt/JupyterLab/resources/app/jlab"

resdir=/opt/JupyterLab/resources

# I - INSTALL Jupyter JULIA KERNEL manually
## 1) kernel files
cp -R "$resdir/jlab_server-dist/share/jupyter/kernels/julia" "$resdir/jlab_server/share/jupyter/kernels/"
## 2) julia depot ...
mkdir "$resdir/jlab_server/julia"
cp -R "$resdir/jlab_server-dist/julia/depot" "$resdir/jlab_server/julia"
## 3) we had to remove the '-1.6' for julia (constructor was not copying the extraResources)... let's put it back
# THIS IS IMPORTANT: otherwise SoS-julia won't bind to IJulia (cf. %use showing "unavailable" language module)
# or you set supported_kernels = {'Julia': ['julia-?.?','julia']} ~line 208 of site-packages/sos-julia/kernel.py
mv "$resdir/jlab_server/share/jupyter/kernels/julia" "$resdir/jlab_server/share/jupyter/kernels/julia-1.6"
## 4) add in fix for Julia Matrix handling
cp "$resdir/jlab_server-dist/lib/python3.8/site-packages/sos_julia/kernel.py" "$resdir/jlab_server/lib/python3.8/site-packages/sos_julia"
## 5) overwrite the Julia pref
echo "$resdir/jlab_server/julia/depot/conda/3/bin/jupyter" > $resdir/jlab_server/julia/depot/prefs/IJulia

# II - INSTALL Jupyter STATA KERNEL manually and handles STATA binding
# cp -R "$2/JupyterLab.app/Contents/Resources/jlab_server-dist/share/jupyter/kernels/stata" "$2/JupyterLab.app/Contents/Resources/jlab_server/share/jupyter/kernels/"
## 1) let's just use the normal command line to handle auto-configuration (this will add the kernel in ~/Library/Jupyter/kernels)
"$resdir/jlab_server/bin/python" -m stata_kernel.install --prefix "$resdir/jlab_server"
## 2) find the Stata executable
if egrep -q '^stata_path.*=\s*$' ~/.stata_kernel.conf; then
    echo "Found empty stata_path in configuration >> will replace"
    stata_exec=$(find /usr/local/stata17/ -type f -name 'stata*' | egrep '^\/.*' | head -n 1)
    if [ -z "$stata_exec" ]
    then
        echo "search for StataIC instead"
        stata_exec=$(find /usr/local/stata17/ -type f -name 'StataIC' | egrep '^\/.*' | head -n 1)
    fi
    ## 3) Fill-in the Stata path we found
    if [ ! -z "$stata_exec" ]
    then
        stata_exec_esc=${stata_exec//\//\\/} # escaped Application Directory for regex replacement
        echo "Found stata path = $stata_exec"
        sed -i '.bak' "s/stata_path.*=\s*/stata_path = $stata_exec_esc/g" ~/.stata_kernel.conf
        # re-run
        "$resdir/jlab_server/bin/python" -m stata_kernel.install --prefix "$resdir/jlab_server"
    fi
fi
## 3) add in fixes:
##    - %help magic function with Stata17 (was crashing on the Copyright processing)
##    - graphics not displaying
cp "$resdir/jlab_server-dist/lib/python3.8/site-packages/stata_kernel/*.py" "$resdir/jlab_server/lib/python3.8/site-packages/stata_kernel"

# III - INSTALL updated SoS kernel to include some ENV variables
cp "$resdir/jlab_server-dist/share/jupyter/kernels/sos/kernel.json" "$resdir/jlab_server/share/jupyter/kernels/sos"

# IV - Rename the paths in kernel.json to be more robust to install directory ...
# replace '~/Applications/JupyterLab.app' with the actual install directory in manually installed kernel.json files
find $resdir/jlab_server/share/jupyter/kernels -name kernel.json -type f -exec sed -i '.bak' "s/~\/Applications\/JupyterLab\.app\/Contents\/Resources/\/opt\/JupyterLab\/resources/g" {} \;

# V  - Install sos_completer lab extension
cp -R "$resdir/jlab_server-dist/share/jupyter/labextensions/sos_completer" "$resdir/jlab_server/share/jupyter/labextensions"
#cp -R "$resdir/jlab_server-dist/share/jupyter/labextensions/sos_completer/schemas/sos_completer" "$resdir/jlab_server/share/jupyter/lab/schemas/"
#mv $resdir/jlab_server/share/jupyter/lab/schemas/sos_completer $resdir/jlab_server/share/jupyter/lab/schemas/sos_completer-extension

# VI - SETUP ENV variables ? (not working)
mkdir -p "$resdir/jlab_server/etc/conda/activate.d"
mkdir -p "$resdir/jlab_server/etc/conda/deactivate.d"
echo -e "#!/bin/sh\n\nexport JULIA_DEPOT_PATH='$resdir/jlab_server/julia/depot'" > "$resdir/jlab_server/etc/conda/activate.d/env_vars.sh"
echo -e "#!/bin/sh\n\nunset JULIA_DEPOT_PATH" > "$resdir/jlab_server/etc/conda/deactivate.d/env_vars.sh"

# VII - finishes Interact.jl install
"$resdir/jlab_server/bin/python3" -m pip install --upgrade "$resdir/jlab_server-dist/wheels/webio_jupyter_extension-0.1.0-py3-none-any.whl"
"$resdir/bin/julia" "$resdir/jlab_server-dist/julia/install_more.jl" "$resdir/bin/jupyter"