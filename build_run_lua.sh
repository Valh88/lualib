#!/bin/sh
# Сборка run_lua (хост: вызов Lua из Pascal) на Linux/Unix.
# Требуется: FPC, liblua.so.5.4 (в LD_LIBRARY_PATH при запуске).

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

echo "Building run_lua (Lua host)..."
fpc -MObjFPC -Scghi -O2 -Tlinux -Px86_64 -Fu"$SRC_DIR" -Fi"$SRC_DIR" -FE"$EXAMPLE_DIR" "$EXAMPLE_DIR/run_lua.lpr"
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Output: $EXAMPLE_DIR/run_lua"
echo "Run: cd example && ./run_lua [script.lua]"
echo "Ensure liblua.so.5.4 is in LD_LIBRARY_PATH if needed."
