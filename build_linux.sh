#!/bin/bash

ROOT_DIR=`pwd`
LIB_DIR="$ROOT_DIR/lib"
SRC_DIR="$ROOT_DIR/src"
INCLUDE_DIR="$ROOT_DIR/include"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

mkdir $LIB_DIR
mkdir $INCLUDE_DIR

TCOD_build()
{
	echo "${GREEN}--- Updating source list..${NC}"
	sudo apt-get update -qq
	echo "${GREEN}--- Installing SDL1.2..${NC}"
	sudo apt-get install libsdl1.2-dev

	cd $SRC_DIR
	cd libtcod

	echo "${GREEN}--- Building TCOD..${NC}"
	make -f makefiles/makefile-linux debug
	echo "${CYAN}--- Copying TCOD libs..${NC}"
	cp ./libtcod_debug.so $LIB_DIR/libtcod.so
	echo "${CYAN}--- Copying TCOD includes..${NC}"
	mkdir $INCLUDE_DIR/tcod
	cp -r include/* $INCLUDE_DIR/tcod
}

TCOD_clean()
{
	cd $SRC_DIR
	cd libtcod

	echo "${BLUE}--- Cleaning TCOD..${NC}"
	rm *.so
	rm lib/libz.a
}

LUA53_build()
{
	cd $SRC_DIR
	cd lua53

	echo "${GREEN}--- Building LUA53..${NC}"
	make linux
	echo "${CYAN}--- Copying LUA53 libs..${NC}"
	cp src/liblua.so $LIB_DIR/liblua.so
	echo "${CYAN}--- Copying LUA53 includes..${NC}"
	mkdir $INCLUDE_DIR/lua
	cp src/lua.h $INCLUDE_DIR/lua
	cp src/luaconf.h $INCLUDE_DIR/lua
	cp src/lualib.h $INCLUDE_DIR/lua
	cp src/lauxlib.h $INCLUDE_DIR/lua
	cp src/lua.hpp $INCLUDE_DIR/lua
}

LUA53_clean()
{
	cd $SRC_DIR
	cd lua53

	echo "${BLUE}--- Cleaning LUA53..${NC}"
	rm src/*.o
	rm src/*.a
	rm src/*.so
	rm src/lua
	rm src/luac
}

if [ "$1" = "clean" ]; then
	TCOD_clean
	LUA53_clean
	rm -rf $LIB_DIR
	rm -rf $INCLUDE_DIR
elif [ "$1" = "tcod" ]; then
	TCOD_build
elif [ "$1" = "lua" ]; then
	LUA53_build
else
	TCOD_build
	LUA53_build
fi

