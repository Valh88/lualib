(******************************************************************************
 * Example Lua 5.4 C module — builds to mymodule.dll (Windows) or mymodule.so (Unix).
 * From Lua: local m = require('mymodule'); print(m.hello())
 ******************************************************************************)

library mymodule;

{$MODE OBJFPC}{$H+}

uses
  lua54,
  lauxlib54;

function hello(L: Plua_State): Integer; cdecl;
begin
  lua_pushstring(L, 'Hello from Pascal!');
  Result := 1;
end;

function luaopen_mymodule(L: Plua_State): Integer; cdecl;
const
  lib: array[0..1] of luaL_Reg = (
    (name: 'hello'; func: @hello),
    (name: nil;   func: nil)
  );
begin
  luaL_checkversion(L);
  lua_createtable(L, 0, 1);
  luaL_setfuncs(L, @lib[0], 0);
  Result := 1;
end;

exports
  luaopen_mymodule name 'luaopen_mymodule';

end.
