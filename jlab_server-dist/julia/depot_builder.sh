#!/bin/sh

BASEDIR=$(dirname "$0")
rm -Rf $BASEDIR/depot
mkdir $BASEDIR/depot
export JULIA_DEPOT_PATH=$BASEDIR/depot; export LD_LIBRARY_PATH=""; julia $BASEDIR/depot_init.jl