(******************************************************************************
 * Пример хоста: вызов Lua из Pascal.
 * Создаёт состояние Lua, подключает стандартные библиотеки, выполняет скрипт
 * или строку кода. Рядом с exe должна быть lua54.dll.
 *
 * Сборка: fpc -Fu"../src" -Fi"../src" run_lua.lpr
 * Запуск: run_lua [файл.lua]   или без аргументов — выполнит встроенную строку.
 ******************************************************************************)

program run_lua;

{$MODE OBJFPC}{$H+}

uses
  SysUtils,
  lua54,
  lauxlib54,
  lualib54;

var
  L: Plua_State;
  script: string;

begin
  L := luaL_newstate;
  if L = nil then
  begin
    Writeln(ErrOutput, 'Failed to create Lua state');
    Halt(1);
  end;
  try
    luaL_openlibs(L);

    if ParamCount >= 1 then
    begin
      script := ParamStr(1);
      if luaL_loadfile(L, PAnsiChar(AnsiString(script))) <> LUA_OK then
      begin
        Writeln(ErrOutput, 'load: ', lua_tostring(L, -1));
        lua_pop(L, 1);
        Halt(1);
      end;
      if lua_pcall(L, 0, 0, 0) <> LUA_OK then
      begin
        Writeln(ErrOutput, 'run: ', lua_tostring(L, -1));
        lua_pop(L, 1);
        Halt(1);
      end;
    end
    else
    begin
      if luaL_loadstring(L, PAnsiChar(AnsiString('print("Hello from Lua, called by Pascal!")'))) <> LUA_OK then
      begin
        Writeln(ErrOutput, lua_tostring(L, -1));
        lua_pop(L, 1);
        Halt(1);
      end;
      if lua_pcall(L, 0, 0, 0) <> LUA_OK then
      begin
        Writeln(ErrOutput, lua_tostring(L, -1));
        lua_pop(L, 1);
        Halt(1);
      end;
    end;
  finally
    lua_close(L);
  end;
end.
