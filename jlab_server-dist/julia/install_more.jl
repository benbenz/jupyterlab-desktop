using WebIO
using Pkg
Pkg.build("WebIO")
WebIO.install_jupyter_labextension([ARGS[1]])
WebIO.install_jupyter_nbextension([ARGS[1]])
