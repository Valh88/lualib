(******************************************************************************
 * Lua 5.4 - Auxiliary library Pascal bindings (lauxlib.h)
 ******************************************************************************)

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

unit lauxlib54;

interface

uses
  lua54;

const
  LUA54_LIB = lua54.LUA54_LIB;

  LUA_GNAME         = '_G';
  LUA_ERRFILE       = LUA_ERRERR + 1;
  LUA_LOADED_TABLE  = '_LOADED';
  LUA_PRELOAD_TABLE = '_PRELOAD';

  LUA_NOREF         = -2;
  LUA_REFNIL        = -1;

  //(* Buffer size: 16 * sizeof(void*) * sizeof(lua_Number); 64-bit: 1024 *)
  LUAL_BUFFERSIZE   = 1024;

  LUA_FILEHANDLE    = 'FILE*';

type
  luaL_Reg = record
    name: PAnsiChar;
    func: lua_CFunction;
  end;
  PluaL_Reg = ^luaL_Reg;

  luaL_Buffer = record
    b: PAnsiChar;
    size: size_t;
    n: size_t;
    L: Plua_State;
    init_buf: array[0..LUAL_BUFFERSIZE - 1] of AnsiChar;
  end;
  PluaL_Buffer = ^luaL_Buffer;

  luaL_Stream = record
    f: Pointer;       (* FILE* *)
    closef: lua_CFunction;
  end;
  PluaL_Stream = ^luaL_Stream;

(* LUAL_NUMSIZES = sizeof(lua_Integer)*16 + sizeof(lua_Number) - for luaL_checkversion_ *)
procedure luaL_checkversion_(L: Plua_State; ver: lua_Number; sz: size_t); cdecl; external LUA54_LIB;

function luaL_getmetafield(L: Plua_State; obj: Integer; const e: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_callmeta(L: Plua_State; obj: Integer; const e: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_tolstring(L: Plua_State; idx: Integer; len: Psize_t): PAnsiChar; cdecl; external LUA54_LIB;
function luaL_argerror(L: Plua_State; arg: Integer; const extramsg: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_typeerror(L: Plua_State; arg: Integer; const tname: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_checklstring(L: Plua_State; arg: Integer; len: Psize_t): PAnsiChar; cdecl; external LUA54_LIB;
function luaL_optlstring(L: Plua_State; arg: Integer; const def: PAnsiChar; len: Psize_t): PAnsiChar; cdecl; external LUA54_LIB;
function luaL_checknumber(L: Plua_State; arg: Integer): lua_Number; cdecl; external LUA54_LIB;
function luaL_optnumber(L: Plua_State; arg: Integer; def: lua_Number): lua_Number; cdecl; external LUA54_LIB;
function luaL_checkinteger(L: Plua_State; arg: Integer): lua_Integer; cdecl; external LUA54_LIB;
function luaL_optinteger(L: Plua_State; arg: Integer; def: lua_Integer): lua_Integer; cdecl; external LUA54_LIB;

procedure luaL_checkstack(L: Plua_State; sz: Integer; const msg: PAnsiChar); cdecl; external LUA54_LIB;
procedure luaL_checktype(L: Plua_State; arg, t: Integer); cdecl; external LUA54_LIB;
procedure luaL_checkany(L: Plua_State; arg: Integer); cdecl; external LUA54_LIB;

function luaL_newmetatable(L: Plua_State; const tname: PAnsiChar): LongBool; cdecl; external LUA54_LIB;
procedure luaL_setmetatable(L: Plua_State; const tname: PAnsiChar); cdecl; external LUA54_LIB;
function luaL_testudata(L: Plua_State; ud: Integer; const tname: PAnsiChar): Pointer; cdecl; external LUA54_LIB;
function luaL_checkudata(L: Plua_State; ud: Integer; const tname: PAnsiChar): Pointer; cdecl; external LUA54_LIB;

procedure luaL_where(L: Plua_State; lvl: Integer); cdecl; external LUA54_LIB;
function luaL_error(L: Plua_State; const fmt: PAnsiChar): Integer; cdecl; varargs; external LUA54_LIB;

function luaL_checkoption(L: Plua_State; arg: Integer; const def: PAnsiChar; const lst: PPAnsiChar): Integer; cdecl; external LUA54_LIB;

function luaL_fileresult(L: Plua_State; stat: Integer; const fname: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_execresult(L: Plua_State; stat: Integer): Integer; cdecl; external LUA54_LIB;

function luaL_ref(L: Plua_State; t: Integer): Integer; cdecl; external LUA54_LIB;
procedure luaL_unref(L: Plua_State; t, ref: Integer); cdecl; external LUA54_LIB;

function luaL_loadfilex(L: Plua_State; const filename, mode: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_loadbufferx(L: Plua_State; const buff: PAnsiChar; sz: size_t; const name, mode: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function luaL_loadstring(L: Plua_State; const s: PAnsiChar): Integer; cdecl; external LUA54_LIB;

function luaL_newstate: Plua_State; cdecl; external LUA54_LIB;

function luaL_len(L: Plua_State; idx: Integer): lua_Integer; cdecl; external LUA54_LIB;

procedure luaL_addgsub(L: PluaL_Buffer; const s, p, r: PAnsiChar); cdecl; external LUA54_LIB;
function luaL_gsub(L: Plua_State; const s, p, r: PAnsiChar): PAnsiChar; cdecl; external LUA54_LIB;

procedure luaL_setfuncs(L: Plua_State; const reg: PluaL_Reg; nup: Integer); cdecl; external LUA54_LIB;
function luaL_getsubtable(L: Plua_State; idx: Integer; const fname: PAnsiChar): LongBool; cdecl; external LUA54_LIB;
procedure luaL_traceback(L: Plua_State; L1: Plua_State; const msg: PAnsiChar; level: Integer); cdecl; external LUA54_LIB;
procedure luaL_requiref(L: Plua_State; const modname: PAnsiChar; openf: lua_CFunction; glb: LongBool); cdecl; external LUA54_LIB;

(* Buffer *)
procedure luaL_buffinit(L: Plua_State; B: PluaL_Buffer); cdecl; external LUA54_LIB;
function luaL_prepbuffsize(B: PluaL_Buffer; sz: size_t): PAnsiChar; cdecl; external LUA54_LIB;
procedure luaL_addlstring(B: PluaL_Buffer; const s: PAnsiChar; len: size_t); cdecl; external LUA54_LIB;
procedure luaL_addstring(B: PluaL_Buffer; const s: PAnsiChar); cdecl; external LUA54_LIB;
procedure luaL_addvalue(B: PluaL_Buffer); cdecl; external LUA54_LIB;
procedure luaL_pushresult(B: PluaL_Buffer); cdecl; external LUA54_LIB;
procedure luaL_pushresultsize(B: PluaL_Buffer; sz: size_t); cdecl; external LUA54_LIB;
function luaL_buffinitsize(L: Plua_State; B: PluaL_Buffer; sz: size_t): PAnsiChar; cdecl; external LUA54_LIB;

(* Convenience *)
procedure luaL_checkversion(L: Plua_State); inline;
function luaL_loadfile(L: Plua_State; const filename: PAnsiChar): Integer; inline;
function luaL_loadbuffer(L: Plua_State; const buff: PAnsiChar; sz: size_t; const name: PAnsiChar): Integer; inline;
function luaL_prepbuffer(B: PluaL_Buffer): PAnsiChar; inline;
function luaL_checkstring(L: Plua_State; n: Integer): PAnsiChar; inline;
function luaL_optstring(L: Plua_State; n: Integer; d: PAnsiChar): PAnsiChar; inline;
function luaL_typename(L: Plua_State; i: Integer): PAnsiChar; inline;
procedure luaL_argcheck(L: Plua_State; cond: Boolean; arg: Integer; extramsg: PAnsiChar); inline;

(* luaL_newlibtable(L, l) = lua_createtable(L, 0, count); use with luaL_setfuncs(L, l, 0) *)
(* luaL_newlib(L, l) = checkversion + newlibtable + setfuncs; l is sentinel-terminated (name=nil) *)

implementation

const
  LUAL_NUMSIZES = SizeOf(lua_Integer) * 16 + SizeOf(lua_Number);

procedure luaL_checkversion(L: Plua_State);
begin
  luaL_checkversion_(L, LUA_VERSION_NUM, LUAL_NUMSIZES);
end;

function luaL_loadfile(L: Plua_State; const filename: PAnsiChar): Integer;
begin
  Result := luaL_loadfilex(L, filename, nil);
end;

function luaL_loadbuffer(L: Plua_State; const buff: PAnsiChar; sz: size_t; const name: PAnsiChar): Integer;
begin
  Result := luaL_loadbufferx(L, buff, sz, name, nil);
end;

function luaL_prepbuffer(B: PluaL_Buffer): PAnsiChar;
begin
  Result := luaL_prepbuffsize(B, LUAL_BUFFERSIZE);
end;

function luaL_checkstring(L: Plua_State; n: Integer): PAnsiChar;
begin
  Result := luaL_checklstring(L, n, nil);
end;

function luaL_optstring(L: Plua_State; n: Integer; d: PAnsiChar): PAnsiChar;
begin
  Result := luaL_optlstring(L, n, d, nil);
end;

function luaL_typename(L: Plua_State; i: Integer): PAnsiChar;
begin
  Result := lua_typename(L, lua_type(L, i));
end;

procedure luaL_argcheck(L: Plua_State; cond: Boolean; arg: Integer; extramsg: PAnsiChar);
begin
  if not cond then
    luaL_argerror(L, arg, extramsg);
end;

end.
