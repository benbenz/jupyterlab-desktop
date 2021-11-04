#!/bin/sh

BASEDIR=$(dirname "$0")
export JULIA_DEPOT_PATH=$BASEDIR/depot; julia $BASEDIR/depot_init.jl