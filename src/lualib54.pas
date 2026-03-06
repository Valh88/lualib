(******************************************************************************
 * Lua 5.4 - Standard libraries (lualib.h) - for embedding host
 * Optional: only needed when building a Lua host in Pascal.
 ******************************************************************************)

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

unit lualib54;

interface

uses
  lua54;

const
  LUA54_LIB = lua54.LUA54_LIB;

  LUA_COLIBNAME   = 'coroutine';
  LUA_TABLIBNAME  = 'table';
  LUA_IOLIBNAME   = 'io';
  LUA_OSLIBNAME   = 'os';
  LUA_STRLIBNAME  = 'string';
  LUA_UTF8LIBNAME = 'utf8';
  LUA_MATHLIBNAME = 'math';
  LUA_DBLIBNAME   = 'debug';
  LUA_LOADLIBNAME = 'package';

function luaopen_base(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_coroutine(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_table(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_io(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_os(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_string(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_utf8(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_math(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_debug(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function luaopen_package(L: Plua_State): Integer; cdecl; external LUA54_LIB;

procedure luaL_openlibs(L: Plua_State); cdecl; external LUA54_LIB;

implementation

end.
