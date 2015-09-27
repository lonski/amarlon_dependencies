#!/bin/sh

ROOT_DIR=`pwd`
LIB_DIR="$ROOT_DIR/lib"
SRC_DIR="$ROOT_DIR/src"

#TCOD
cd $SRC_DIR
cd libtcod
make -f makefiles/makefile-linux debug

cp ./libtcod_debug.so $LIB_DIR/libtcod.so
