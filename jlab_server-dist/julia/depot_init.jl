using Pkg

# Pkg.add("BinaryBuilder")
Pkg.add("IJulia")
Pkg.add("NamedArrays")
Pkg.add("Feather")
Pkg.add("DataFrames")
Pkg.add("Conda")
# Problems with Plots > GR > GR_jll > Qt5Base:
# - dylib not found
# - if renamed 'binary' to .dylib >> issue with _NSAppearanceNameDarkAqua not found (this is only avail. on 10.14!))
# cf. here: https://discourse.julialang.org/t/problem-with-qt-dependency-of-plots-jl/58765
# cf. here: https://github.com/jheinen/GR.jl/issues/392
# v1.1.2 is causing the dylib not found error (and subsequently the _NSAppearanceNameDarkAqua when renaming the framework binaries to dylib)
# v1.1.1 is causing the _NSAppearanceNameDarkAqua not found error 
ENV["JULIA_GR_PROVIDER"] = "GR" 
Pkg.add(Pkg.PackageSpec(;name="Plots", version="1.1.0"))

# precompile the packages ? 
Pkg.precompile()