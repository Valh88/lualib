#!/bin/sh
# Сборка mymodule.so (Lua 5.4 C-модуль) на Linux/Unix.
# Требуется: FPC, liblua.so.5.4 (или в LD_LIBRARY_PATH).
# Если FPC установлен через fpcupdeluxe и сборка не находит unit system — задайте FPCDIR (каталог fpc).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
EXAMPLE_DIR="$SCRIPT_DIR/example"

# FPC из fpcupdeluxe часто не подхватывает конфиг: задаём FPCDIR, если не задан
if [ -z "$FPCDIR" ]; then
  FPC_BIN="$(command -v fpc 2>/dev/null)"
  if [ -n "$FPC_BIN" ]; then
    FPC_ROOT="$(cd "$(dirname "$FPC_BIN")/../.." 2>/dev/null && pwd)"
    if [ -d "$FPC_ROOT/units" ]; then
      export FPCDIR="$FPC_ROOT"
    fi
  fi
fi

echo "Building mymodule (Lua 5.4 module)..."
# -o не поддерживается для library в FPC; по умолчанию получается libmymodule.so — переименуем в mymodule.so для require('mymodule')
fpc -MObjFPC -Scghi -O2 -Tlinux -Px86_64 -Fu"$SRC_DIR" -Fi"$SRC_DIR" -FE"$EXAMPLE_DIR" "$EXAMPLE_DIR/mymodule.lpr"
if [ $? -ne 0 ]; then exit 1; fi

# FPC создаёт libmymodule.so, Lua по require('mymodule') ищет mymodule.so
if [ -f "$EXAMPLE_DIR/libmymodule.so" ]; then
  mv "$EXAMPLE_DIR/libmymodule.so" "$EXAMPLE_DIR/mymodule.so"
fi

echo ""
echo "Output: $EXAMPLE_DIR/mymodule.so"
echo "Place mymodule.so where Lua can find it (package.cpath) and ensure liblua.so.5.4 is in LD_LIBRARY_PATH or system lib path."
echo "Test: lua test_mymodule.lua"
