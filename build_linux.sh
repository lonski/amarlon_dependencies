#!/bin/bash

ROOT_DIR=`pwd`
LIB_DIR="$ROOT_DIR/lib"
SRC_DIR="$ROOT_DIR/src"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TCOD_build()
{
	cd $SRC_DIR
	cd libtcod

	echo "${GREEN}--- Building TCOD..${NC}"
	make -f makefiles/makefile-linux debug
	echo "${CYAN}--- Copying TCOD libs..${NC}"
	cp ./libtcod_debug.so $LIB_DIR/libtcod.so
}

TCOD_clean()
{
	cd $SRC_DIR
	cd libtcod

	echo "${BLUE}--- Cleaning TCOD..${NC}"
	rm *.so
	rm lib/libz.a
	rm $LIB_DIR/libtcod.so
}

if [ "$1" = "clean" ] 
then
	TCOD_clean
else
	TCOD_build
fi

