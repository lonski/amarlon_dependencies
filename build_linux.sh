#!/bin/bash

ROOT_DIR=`pwd`
LIB_DIR="$ROOT_DIR/lib"
SRC_DIR="$ROOT_DIR/src"
INCLUDE_DIR="$ROOT_DIR/include"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

set_gcc()
{
    sudo apt-get install build-essential
    sudo apt-get install -qq gcc-5 g++-5 -qq
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20 --slave /usr/bin/g++ g++ /usr/bin/g++-5
    sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
    sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
    sudo update-alternatives --set cc /usr/bin/gcc
    sudo update-alternatives --set c++ /usr/bin/g++
}

before_build()
{
	echo "${GREEN}--- Creating directories..${NC}"
	mkdir $LIB_DIR
	mkdir $INCLUDE_DIR
	echo "${GREEN}--- Updating source list..${NC}"
	echo "yes" | sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu `lsb_release -sc` main universe restricted multiverse"
    echo "yes" | sudo add-apt-repository ppa:ubuntu-toolchain-r/test
	echo "yes" | sudo add-apt-repository ppa:boost-latest/ppa
	sudo apt-get update -qq
	echo "${GREEN}--- Installing GCC5..${NC}"
	set_gcc
	echo "${GREEN}--- Installing SDL1.2..${NC}"
	sudo apt-get install libsdl1.2-dev -qq
	echo "${GREEN}--- Installing CMAKE..${NC}"
	sudo apt-get install cmake -qq
	echo "${GREEN}--- Installing BOOST..${NC}"
	sudo apt-get install libboost1.55-dev -qq
	echo "${GREEN}--- Installing CURL, DH-AUTORECONF..${NC}"
	sudo apt-get install curl dh-autoreconf -qq	
}

PROTOBUF_build()
{
	cd $SRC_DIR
	echo "${GREEN}--- Cloning PROTOBUF source..${NC}"
	git clone https://github.com/google/protobuf.git
	cd protobuf
	echo "${GREEN}--- Configuring PROTOBUF..${NC}"
	./autogen.sh
	./configure
	echo "${GREEN}--- Building PROTOBUF..${NC}"
	make -j2
	echo "${CYAN}--- Copying PROTOBUF libs..${NC}"
	cp src/.libs/libprotobuf.so $LIB_DIR/libprotobuf.so
}

PROTOBUF_clean()
{
	cd $SRC_DIR
	echo "${BLUE}--- Cleaning TCOD..${NC}"
	rm -rf protobuf
}

TCOD_build()
{
	cd $SRC_DIR
	cd libtcod

	echo "${GREEN}--- Building TCOD..${NC}"
	make -f makefiles/makefile-linux debug
	echo "${CYAN}--- Copying TCOD libs..${NC}"
	cp ./libtcod_debug.so $LIB_DIR/libtcod.so
	cp ./libtcodxx_debug.so $LIB_DIR/libtcodxx.so
	cp ./libtcod_debug.so $LIB_DIR/libtcod_debug.so
	cp ./libtcodxx_debug.so $LIB_DIR/libtcodxx_debug.so
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

LUABIND_build()
{
	cd $SRC_DIR
	cd luabind

	echo "${GREEN}--- Building LUABIND09..${NC}"
	mkdir include
	mkdir lib
	cp -r $INCLUDE_DIR/lua include
	cp $LIB_DIR/liblua.so lib/

	echo "${GREEN}--- Building LUABIND09..${NC}"
	mkdir build
	cd build
	cmake .. -DLUABIND_DYNAMIC_LINK=1 -DBUILD_TESTING=0
	make -j2

	echo "${CYAN}--- Copying LUABIND09 libs..${NC}"
	cp src/libluabind09.so $LIB_DIR/libluabind09.so
	echo "${CYAN}--- Copying LUABIND09 includes..${NC}"
	cp -r ../luabind $INCLUDE_DIR
	touch $INCLUDE_DIR/luabind/build_information.hpp
}

XML_build()
{
	echo "${CYAN}--- Copying RAPIDXML includes..${NC}"
	cp -r $SRC_DIR/rapidxml $INCLUDE_DIR/xml
}

LUABIND_clean()
{
	cd $SRC_DIR
	cd luabind

	echo "${BLUE}--- Cleaning LUABIND09..${NC}"
	rm -rf build
	rm -rf include
	rm -rf lib
}

GTEST_build()
{
	cd $SRC_DIR
	cd gtest
	mkdir build
	cd build

	echo "${GREEN}--- Building GTEST..${NC}"
	cmake .. -DBUILD_SHARED_LIBS=1
	make -j`grep -c processor /proc/cpuinfo`

	echo "${CYAN}--- Copying GTEST libs..${NC}"
	cp libgtest.so $LIB_DIR/libgtest.so
	cp libgtest_main.so $LIB_DIR/libgtest_main.so

	echo "${CYAN}--- Copying GTEST includes..${NC}"
	cp -r ../include/gtest $INCLUDE_DIR
}

GTEST_clean()
{
	cd $SRC_DIR
	cd gtest

	echo "${BLUE}--- Cleaning GTEST..${NC}"
	rm -rf build
}

GMOCK_build()
{
	cd $SRC_DIR
	cd gmock
	mkdir build
	cd build

	echo "${GREEN}--- Building GMOCK..${NC}"
	cmake .. -DBUILD_SHARED_LIBS=1
	make -j`grep -c processor /proc/cpuinfo`

	echo "${CYAN}--- Copying GMOCK libs..${NC}"
	cp libgmock.so $LIB_DIR/libgmock.so
	cp libgmock_main.so $LIB_DIR/libgmock_main.so

	echo "${CYAN}--- Copying GMOCK includes..${NC}"
	cp -r ../include/gmock $INCLUDE_DIR
}

GMOCK_clean()
{
	cd $SRC_DIR
	cd gmock

	echo "${BLUE}--- Cleaning GMOCK..${NC}"
	rm -rf build
}

if [ "$1" = "clean" ]; then
	TCOD_clean
	LUA53_clean
	LUABIND_clean
	GMOCK_clean
	GTEST_clean
	PROTOBUF_clean
	echo "${BLUE}--- Cleaning lib & include directories..${NC}"
	rm -rf $LIB_DIR
	rm -rf $INCLUDE_DIR
else
	before_build

	if [ "$1" = "tcod" ]; then
		TCOD_build
	elif [ "$1" = "lua" ]; then
		LUA53_build
	elif [ "$1" = "luabind" ]; then
		LUABIND_build
	elif [ "$1" = "gtest" ]; then
		GTEST_build
	elif [ "$1" = "gmock" ]; then
		GMOCK_build
	elif [ "$1" = "xml" ]; then
		XML_build
	elif [ "$1" = "proto" ]; then
		PROTOBUF_build
	else		
		GTEST_build
		GMOCK_build
		XML_build
		TCOD_build
		LUA53_build
		LUABIND_build
		PROTOBUF_build
	fi
fi

