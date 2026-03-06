#!/bin/sh
# Сборка mymodule.so (Lua 5.4 C-модуль) на Linux/Unix.
# Требуется: FPC, liblua.so.5.4 (или в LD_LIBRARY_PATH).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
EXAMPLE_DIR="$SCRIPT_DIR/example"

echo "Building mymodule (Lua 5.4 module)..."
# -o mymodule.so: Lua ищет mymodule.so по require('mymodule'); FPC по умолчанию создаёт libmymodule.so
fpc -MObjFPC -Scghi -O2 -Tlinux -Px86_64 -Fu"$SRC_DIR" -Fi"$SRC_DIR" -FE"$EXAMPLE_DIR" -o mymodule.so "$EXAMPLE_DIR/mymodule.lpr"
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Output: $EXAMPLE_DIR/mymodule.so"
echo "Place mymodule.so where Lua can find it (package.cpath) and ensure liblua.so.5.4 is in LD_LIBRARY_PATH or system lib path."
echo "Test: lua test_mymodule.lua"
