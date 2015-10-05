@echo off

set "ROOT_DIR=%CD%"
set "LIBS_DIR=%CD%\lib"
set "INCLUDE_DIR=%CD%\include"

echo.2015r (c) Michal Lonski michal@lonski.pl
echo.Amarlon Dependency builder

echo.
echo.=====================READ! THIS MAY HELP!===================
echo. 
echo.1. You need to have CMAKE installed and added to PATH
echo.2. You need to have MinGW installed and added to PATH
echo    in specific you should have:
echo.   - mingw32-make.exe
echo.   - mingw32-gcc.exe
echo.   - mingw32-g++.exe
echo. 
echo.  If you use Qt Creator and you specified path 
echo.  to mingw as "Qt\Tools\mingw491_32\bin\"
echo.  Then you may need to copy "g++.exe" to "mingw32-g++.exe" 
echo.  and "gcc.exe" to "mingw32-gcc.exe"
echo. 
echo.============================================================
echo. 
echo.&pause

call:BEFORE_BUILD
call:GTEST_BUILD
call:GMOCK_BUILD
call:TCOD_BUILD
call:LUA_BUILD
call:LUABIND_BUILD
call:XML_BUILD
call:BOOST_BUILD

cd %ROOT_DIR%

echo. 
echo.============================================================
echo. 
echo.Finished.
echo.All DLLs compiled are in %LIBS_DIR%
echo.All necessary includes are in %INCLUDE_DIR%
echo. 
echo.&pause
call:CLEAN
GOTO:EOF

:BEFORE_BUILD
mkdir %LIBS_DIR%
mkdir %INCLUDE_DIR%
GOTO:EOF

:CLEAN
call::GTEST_CLEAN
call:GMOCK_CLEAN
call:TCOD_CLEAN
call:LUA_CLEAN
call:LUABIND_CLEAN
GOTO:EOF

:XML_BUILD
echo.Copying RAPIDXML includes...
mkdir %INCLUDE_DIR%\xml
xcopy /R /E /Y %ROOT_DIR%\src\rapidxml %INCLUDE_DIR%\xml
GOTO:EOF

:BOOST_BUILD
echo.Copying BOOST includes...
mkdir %INCLUDE_DIR%\xml
xcopy /R /E /Y %ROOT_DIR%\src\boost %INCLUDE_DIR%\boost
GOTO:EOF

:LUABIND_BUILD
echo.Building LUABIND...
cd %ROOT_DIR%\src\luabind
mkdir build
cd build
cmake -G"MinGW Makefiles" .. -DLUABIND_DYNAMIC_LINK=1 -DBUILD_TESTING=0 -DBOOST_ROOT="%ROOT_DIR%\src" -DLUA_INCLUDE_DIR="%ROOT_DIR%\include\lua"
mingw32-make -j2
echo.Copying LUABIND libs...
copy src\luabind09.dll %LIBS_DIR%\luabind09.dll
echo.Copying LUABIND includes...
mkdir %INCLUDE_DIR%\luabind
xcopy /R /E /Y ..\luabind %INCLUDE_DIR%\luabind
GOTO:EOF

:LUABIND_CLEAN
echo.Cleaning LUABIND...
rmdir /S /Q %ROOT_DIR%\src\luabind\build
GOTO:EOF

:LUA_CLEAN
echo.Cleaning LUABIND...
del /F /Q %ROOT_DIR%\src\lua53\src\*.exe
del /F /Q %ROOT_DIR%\src\lua53\src\*.o
del /F /Q %ROOT_DIR%\src\lua53\src\*.a
del /F /Q %ROOT_DIR%\src\lua53\src\*.dll
::del /F /Q %ROOT_DIR%\src\luabind\lua.dll
GOTO:EOF

:LUA_BUILD
echo.Building LUA...
cd %ROOT_DIR%\src\lua53
mingw32-make PLAT=mingw CXX=mingw32-g++ CC=mingw32-gcc -j2
echo.Copying LUA libs...
copy src\lua53.dll %LIBS_DIR%\lua.dll
::copy src\lua53.dll %ROOT_DIR%\src\luabind\lua.dll
echo.Copying LUA includes...
mkdir %INCLUDE_DIR%\lua
copy src\lua.h %INCLUDE_DIR%\lua
copy src\luaconf.h %INCLUDE_DIR%\lua
copy src\lualib.h %INCLUDE_DIR%\lua
copy src\lauxlib.h %INCLUDE_DIR%\lua
copy src\lua.hpp %INCLUDE_DIR%\lua	
GOTO:EOF

:LUA_CLEAN
echo.Cleaning LUA...
del /F /Q %ROOT_DIR%\src\lua53\src\*.exe
del /F /Q %ROOT_DIR%\src\lua53\src\*.o
del /F /Q %ROOT_DIR%\src\lua53\src\*.a
del /F /Q %ROOT_DIR%\src\lua53\src\*.dll
del /F /Q %ROOT_DIR%\src\luabind\lua.dll
GOTO:EOF

:TCOD_BUILD
echo.Building TCOD...
cd %ROOT_DIR%\src\libtcod
mingw32-make -f makefiles\makefile-mingw
echo.Copying TCOD libs...
copy libtcod-mingw.dll %LIBS_DIR%\libtcod.dll
copy libtcod-mingw-debug.dll %LIBS_DIR%\libtcod-debug.dll
copy libtcod-mingw.dll %LIBS_DIR%\libtcodxx.dll
copy libtcod-mingw-debug.dll %LIBS_DIR%\libtcodxx-debug.dll
echo.Copying TCOD includes...
mkdir %INCLUDE_DIR%\tcod
xcopy /R /E /Y include %INCLUDE_DIR%\tcod
GOTO:EOF

:TCOD_CLEAN
echo.Cleaning TCOD...
del /F /Q %ROOT_DIR%\src\libtcod\libtcod-gui-mingw.dll
del /F /Q %ROOT_DIR%\src\libtcod\libtcod-gui-mingw-debug.dll
del /F /Q %ROOT_DIR%\src\libtcod\libtcod-mingw.dll
del /F /Q %ROOT_DIR%\src\libtcod\libtcod-mingw-debug.dll
del /F /Q %ROOT_DIR%\src\libtcod\lib\*.a
GOTO:EOF

:GTEST_BUILD
echo.Building GTEST...
cd %ROOT_DIR%\src\gtest
mkdir build
cd build
cmake -G"MinGW Makefiles" .. -DBUILD_SHARED_LIBS=1
mingw32-make
echo.Copying GTEST libs...
copy libgtest.dll %LIBS_DIR%
copy libgtest_main.dll %LIBS_DIR%
echo.Copying GTEST includes...
mkdir %INCLUDE_DIR%\gtest
xcopy /R /E /Y ..\include\gtest %INCLUDE_DIR%\gtest
GOTO:EOF

:GTEST_CLEAN
echo.Cleaning GTEST...
rmdir /S /Q %ROOT_DIR%\src\gtest\build
GOTO:EOF

:GMOCK_BUILD
echo.Building GMOCK...
cd %ROOT_DIR%\src\gmock
mkdir build
cd build
cmake -G"MinGW Makefiles" .. -DBUILD_SHARED_LIBS=1
mingw32-make
echo.Copying GMOCK libs...
copy libgmock.dll %LIBS_DIR%
copy libgmock_main.dll %LIBS_DIR%
echo.Copying GMOCK includes...
mkdir %INCLUDE_DIR%\gmock
xcopy /R /E /Y ..\include\gmock %INCLUDE_DIR%\gmock
GOTO:EOF

:GMOCK_CLEAN
echo.Cleaning GMOCK...
rmdir /S /Q %ROOT_DIR%\src\gmock\build
GOTO:EOF