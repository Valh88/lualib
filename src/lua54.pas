(******************************************************************************
 * Lua 5.4 - Pascal bindings to C API
 * For use with Free Pascal; dynamic link to lua54.dll / liblua.so.5.4
 ******************************************************************************)

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$ENDIF}

unit lua54;

interface

const
  {$IFDEF UNIX}
  LUA54_LIB = 'liblua.so.5.4';
  {$ELSE}
  LUA54_LIB = 'lua54.dll';
  {$ENDIF}

type
  size_t = Cardinal;
  Psize_t = ^size_t;

const
  LUA_VERSION_MAJOR   = '5';
  LUA_VERSION_MINOR   = '4';
  LUA_VERSION_NUM     = 504;
  LUA_VERSION_RELEASE = 'Lua 5.4';
  LUA_COPYRIGHT       = 'Copyright (C) 1994-2025 Lua.org, PUC-Rio';
  LUA_AUTHORS         = 'R. Ierusalimschy, L. H. de Figueiredo, W. Celes';

  LUA_SIGNATURE       = #27 + 'Lua';

  LUA_MULTRET         = -1;

  (* Pseudo-indices: LUA_REGISTRYINDEX = -LUAI_MAXSTACK - 1000 *)
  LUAI_MAXSTACK       = 1000000;
  LUA_REGISTRYINDEX   = -(LUAI_MAXSTACK + 1000);

  (* Thread status; LUA_YIELD_ to avoid clash with function lua_yield *)
  LUA_OK              = 0;
  LUA_YIELD_          = 1;
  LUA_ERRRUN          = 2;
  LUA_ERRSYNTAX       = 3;
  LUA_ERRMEM          = 4;
  LUA_ERRERR          = 5;

  (* Type constants *)
  LUA_TNONE           = -1;
  LUA_TNIL            = 0;
  LUA_TBOOLEAN        = 1;
  LUA_TLIGHTUSERDATA  = 2;
  LUA_TNUMBER         = 3;
  LUA_TSTRING         = 4;
  LUA_TTABLE          = 5;
  LUA_TFUNCTION       = 6;
  LUA_TUSERDATA       = 7;
  LUA_TTHREAD         = 8;
  LUA_NUMTYPES        = 9;

  LUA_MINSTACK        = 20;

  (* Registry predefined indices *)
  LUA_RIDX_MAINTHREAD = 1;
  LUA_RIDX_GLOBALS    = 2;
  LUA_RIDX_LAST       = LUA_RIDX_GLOBALS;

  (* Arithmetic and comparison ops *)
  LUA_OPADD           = 0;
  LUA_OPSUB           = 1;
  LUA_OPMUL           = 2;
  LUA_OPMOD           = 3;
  LUA_OPPOW           = 4;
  LUA_OPDIV           = 5;
  LUA_OPIDIV          = 6;
  LUA_OPBAND          = 7;
  LUA_OPBOR           = 8;
  LUA_OPBXOR          = 9;
  LUA_OPSHL           = 10;
  LUA_OPSHR           = 11;
  LUA_OPUNM           = 12;
  LUA_OPBNOT          = 13;

  LUA_OPEQ            = 0;
  LUA_OPLT            = 1;
  LUA_OPLE            = 2;

  (* GC options *)
  LUA_GCSTOP          = 0;
  LUA_GCRESTART       = 1;
  LUA_GCCOLLECT       = 2;
  LUA_GCCOUNT         = 3;
  LUA_GCCOUNTB        = 4;
  LUA_GCSTEP          = 5;
  LUA_GCSETPAUSE      = 6;
  LUA_GCSETSTEPMUL    = 7;
  LUA_GCISRUNNING     = 9;
  LUA_GCGEN           = 10;
  LUA_GCINC           = 11;

  (* Hook events *)
  LUA_HOOKCALL        = 0;
  LUA_HOOKRET         = 1;
  LUA_HOOKLINE        = 2;
  LUA_HOOKCOUNT       = 3;
  LUA_HOOKTAILCALL    = 4;

  LUA_MASKCALL        = 1 shl LUA_HOOKCALL;
  LUA_MASKRET         = 1 shl LUA_HOOKRET;
  LUA_MASKLINE        = 1 shl LUA_HOOKLINE;
  LUA_MASKCOUNT       = 1 shl LUA_HOOKCOUNT;

  LUA_IDSIZE          = 60;

type
  Plua_State = Pointer;

  lua_Number = Double;
  lua_Integer = PtrInt;
  lua_Unsigned = PtrUInt;
  lua_KContext = PtrInt;

  lua_CFunction = function(L: Plua_State): Integer; cdecl;

  lua_KFunction = function(L: Plua_State; status: Integer; ctx: lua_KContext): Integer; cdecl;

  lua_Reader = function(L: Plua_State; ud: Pointer; sz: Psize_t): PAnsiChar; cdecl;
  lua_Writer = function(L: Plua_State; const p: Pointer; sz: size_t; ud: Pointer): Integer; cdecl;

  lua_Alloc = function(ud, ptr: Pointer; osize, nsize: size_t): Pointer; cdecl;

  lua_WarnFunction = procedure(ud: Pointer; const msg: PAnsiChar; tocont: Integer); cdecl;

  lua_Debug = record
    event: Integer;
    name: PAnsiChar;
    namewhat: PAnsiChar;
    what: PAnsiChar;
    source: PAnsiChar;
    srclen: size_t;
    currentline: Integer;
    linedefined: Integer;
    lastlinedefined: Integer;
    nups: Byte;
    nparams: Byte;
    isvararg: Byte;
    istailcall: Byte;
    ftransfer: Word;
    ntransfer: Word;
    short_src: array[0..LUA_IDSIZE - 1] of AnsiChar;
    i_ci: Pointer;  (* CallInfo *, opaque *)
  end;
  Plua_Debug = ^lua_Debug;

  lua_Hook = procedure(L: Plua_State; ar: Plua_Debug); cdecl;

function lua_upvalueindex(i: Integer): Integer; inline;

(* State manipulation *)
function lua_newstate(f: lua_Alloc; ud: Pointer): Plua_State; cdecl; external LUA54_LIB;
procedure lua_close(L: Plua_State); cdecl; external LUA54_LIB;
function lua_newthread(L: Plua_State): Plua_State; cdecl; external LUA54_LIB;
function lua_closethread(L: Plua_State; from: Plua_State): Integer; cdecl; external LUA54_LIB;
function lua_resetthread(L: Plua_State): Integer; cdecl; external LUA54_LIB;

function lua_atpanic(L: Plua_State; panicf: lua_CFunction): lua_CFunction; cdecl; external LUA54_LIB;

function lua_version(L: Plua_State): lua_Number; cdecl; external LUA54_LIB;

(* Stack manipulation *)
function lua_absindex(L: Plua_State; idx: Integer): Integer; cdecl; external LUA54_LIB;
function lua_gettop(L: Plua_State): Integer; cdecl; external LUA54_LIB;
procedure lua_settop(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;
procedure lua_pushvalue(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;
procedure lua_rotate(L: Plua_State; idx, n: Integer); cdecl; external LUA54_LIB;
procedure lua_copy(L: Plua_State; fromidx, toidx: Integer); cdecl; external LUA54_LIB;
function lua_checkstack(L: Plua_State; n: Integer): LongBool; cdecl; external LUA54_LIB;

procedure lua_xmove(from, to_: Plua_State; n: Integer); cdecl; external LUA54_LIB;

(* Access functions *)
function lua_isnumber(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_isstring(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_iscfunction(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_isinteger(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_isuserdata(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_type(L: Plua_State; idx: Integer): Integer; cdecl; external LUA54_LIB;
function lua_typename(L: Plua_State; tp: Integer): PAnsiChar; cdecl; external LUA54_LIB;

function lua_tonumberx(L: Plua_State; idx: Integer; isnum: PInteger): lua_Number; cdecl; external LUA54_LIB;
function lua_tointegerx(L: Plua_State; idx: Integer; isnum: PInteger): lua_Integer; cdecl; external LUA54_LIB;
function lua_toboolean(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_tolstring(L: Plua_State; idx: Integer; len: Psize_t): PAnsiChar; cdecl; external LUA54_LIB;
function lua_rawlen(L: Plua_State; idx: Integer): lua_Unsigned; cdecl; external LUA54_LIB;
function lua_tocfunction(L: Plua_State; idx: Integer): lua_CFunction; cdecl; external LUA54_LIB;
function lua_touserdata(L: Plua_State; idx: Integer): Pointer; cdecl; external LUA54_LIB;
function lua_tothread(L: Plua_State; idx: Integer): Plua_State; cdecl; external LUA54_LIB;
function lua_topointer(L: Plua_State; idx: Integer): Pointer; cdecl; external LUA54_LIB;

(* Comparison and arithmetic *)
procedure lua_arith(L: Plua_State; op: Integer); cdecl; external LUA54_LIB;
function lua_rawequal(L: Plua_State; idx1, idx2: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_compare(L: Plua_State; idx1, idx2, op: Integer): LongBool; cdecl; external LUA54_LIB;

(* Push functions *)
procedure lua_pushnil(L: Plua_State); cdecl; external LUA54_LIB;
procedure lua_pushnumber(L: Plua_State; n: lua_Number); cdecl; external LUA54_LIB;
procedure lua_pushinteger(L: Plua_State; n: lua_Integer); cdecl; external LUA54_LIB;
function lua_pushlstring(L: Plua_State; const s: PAnsiChar; len: size_t): PAnsiChar; cdecl; external LUA54_LIB;
function lua_pushstring(L: Plua_State; const s: PAnsiChar): PAnsiChar; cdecl; external LUA54_LIB;
function lua_pushvfstring(L: Plua_State; const fmt: PAnsiChar; argp: Pointer): PAnsiChar; cdecl; external LUA54_LIB;
function lua_pushfstring(L: Plua_State; const fmt: PAnsiChar): PAnsiChar; cdecl; varargs; external LUA54_LIB;
procedure lua_pushcclosure(L: Plua_State; fn: lua_CFunction; n: Integer); cdecl; external LUA54_LIB;
procedure lua_pushboolean(L: Plua_State; b: LongBool); cdecl; external LUA54_LIB;
procedure lua_pushlightuserdata(L: Plua_State; p: Pointer); cdecl; external LUA54_LIB;
function lua_pushthread(L: Plua_State): Integer; cdecl; external LUA54_LIB;

(* Get functions *)
function lua_getglobal(L: Plua_State; const name: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function lua_gettable(L: Plua_State; idx: Integer): Integer; cdecl; external LUA54_LIB;
function lua_getfield(L: Plua_State; idx: Integer; const k: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function lua_geti(L: Plua_State; idx: Integer; n: lua_Integer): Integer; cdecl; external LUA54_LIB;
function lua_rawget(L: Plua_State; idx: Integer): Integer; cdecl; external LUA54_LIB;
function lua_rawgeti(L: Plua_State; idx: Integer; n: lua_Integer): Integer; cdecl; external LUA54_LIB;
function lua_rawgetp(L: Plua_State; idx: Integer; p: Pointer): Integer; cdecl; external LUA54_LIB;

procedure lua_createtable(L: Plua_State; narr, nrec: Integer); cdecl; external LUA54_LIB;
function lua_newuserdatauv(L: Plua_State; sz: size_t; nuvalue: Integer): Pointer; cdecl; external LUA54_LIB;
function lua_getmetatable(L: Plua_State; objindex: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_getiuservalue(L: Plua_State; idx, n: Integer): Integer; cdecl; external LUA54_LIB;

(* Set functions *)
procedure lua_setglobal(L: Plua_State; const name: PAnsiChar); cdecl; external LUA54_LIB;
procedure lua_settable(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;
procedure lua_setfield(L: Plua_State; idx: Integer; const k: PAnsiChar); cdecl; external LUA54_LIB;
procedure lua_seti(L: Plua_State; idx: Integer; n: lua_Integer); cdecl; external LUA54_LIB;
procedure lua_rawset(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;
procedure lua_rawseti(L: Plua_State; idx: Integer; n: lua_Integer); cdecl; external LUA54_LIB;
procedure lua_rawsetp(L: Plua_State; idx: Integer; p: Pointer); cdecl; external LUA54_LIB;
function lua_setmetatable(L: Plua_State; objindex: Integer): LongBool; cdecl; external LUA54_LIB;
function lua_setiuservalue(L: Plua_State; idx, n: Integer): Integer; cdecl; external LUA54_LIB;

(* Load and call *)
procedure lua_callk(L: Plua_State; nargs, nresults: Integer; ctx: lua_KContext; k: lua_KFunction); cdecl; external LUA54_LIB;
function lua_pcallk(L: Plua_State; nargs, nresults, errfunc: Integer; ctx: lua_KContext; k: lua_KFunction): Integer; cdecl; external LUA54_LIB;
function lua_load(L: Plua_State; reader: lua_Reader; dt: Pointer; const chunkname, mode: PAnsiChar): Integer; cdecl; external LUA54_LIB;
function lua_dump(L: Plua_State; writer: lua_Writer; data: Pointer; strip: Integer): Integer; cdecl; external LUA54_LIB;

(* Coroutine *)
function lua_yieldk(L: Plua_State; nresults: Integer; ctx: lua_KContext; k: lua_KFunction): Integer; cdecl; external LUA54_LIB;
function lua_resume(L: Plua_State; from: Plua_State; narg: Integer; nres: PInteger): Integer; cdecl; external LUA54_LIB;
function lua_status(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function lua_isyieldable(L: Plua_State): LongBool; cdecl; external LUA54_LIB;

(* Warning *)
procedure lua_setwarnf(L: Plua_State; f: lua_WarnFunction; ud: Pointer); cdecl; external LUA54_LIB;
procedure lua_warning(L: Plua_State; const msg: PAnsiChar; tocont: Integer); cdecl; external LUA54_LIB;

(* GC *)
function lua_gc(L: Plua_State; what: Integer): Integer; cdecl; varargs; external LUA54_LIB;

(* Misc *)
function lua_error(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function lua_next(L: Plua_State; idx: Integer): LongBool; cdecl; external LUA54_LIB;
procedure lua_concat(L: Plua_State; n: Integer); cdecl; external LUA54_LIB;
procedure lua_len(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;

function lua_stringtonumber(L: Plua_State; const s: PAnsiChar): size_t; cdecl; external LUA54_LIB;

function lua_getallocf(L: Plua_State; ud: PPointer): lua_Alloc; cdecl; external LUA54_LIB;
procedure lua_setallocf(L: Plua_State; f: lua_Alloc; ud: Pointer); cdecl; external LUA54_LIB;

procedure lua_toclose(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;
procedure lua_closeslot(L: Plua_State; idx: Integer); cdecl; external LUA54_LIB;

(* Debug *)
function lua_getstack(L: Plua_State; level: Integer; ar: Plua_Debug): LongBool; cdecl; external LUA54_LIB;
function lua_getinfo(L: Plua_State; const what: PAnsiChar; ar: Plua_Debug): LongBool; cdecl; external LUA54_LIB;
function lua_getlocal(L: Plua_State; const ar: Plua_Debug; n: Integer): PAnsiChar; cdecl; external LUA54_LIB;
function lua_setlocal(L: Plua_State; const ar: Plua_Debug; n: Integer): PAnsiChar; cdecl; external LUA54_LIB;
function lua_getupvalue(L: Plua_State; funcindex, n: Integer): PAnsiChar; cdecl; external LUA54_LIB;
function lua_setupvalue(L: Plua_State; funcindex, n: Integer): PAnsiChar; cdecl; external LUA54_LIB;
function lua_upvalueid(L: Plua_State; fidx, n: Integer): Pointer; cdecl; external LUA54_LIB;
procedure lua_upvaluejoin(L: Plua_State; fidx1, n1, fidx2, n2: Integer); cdecl; external LUA54_LIB;
procedure lua_sethook(L: Plua_State; func: lua_Hook; mask, count: Integer); cdecl; external LUA54_LIB;
function lua_gethook(L: Plua_State): lua_Hook; cdecl; external LUA54_LIB;
function lua_gethookmask(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function lua_gethookcount(L: Plua_State): Integer; cdecl; external LUA54_LIB;
function lua_setcstacklimit(L: Plua_State; limit: LongWord): Integer; cdecl; external LUA54_LIB;

(* Convenience macros as procedures/functions *)
procedure lua_pop(L: Plua_State; n: Integer); inline;
procedure lua_newtable(L: Plua_State); inline;
procedure lua_register(L: Plua_State; const n: PAnsiChar; f: lua_CFunction); inline;
procedure lua_pushcfunction(L: Plua_State; f: lua_CFunction); inline;
procedure lua_insert(L: Plua_State; idx: Integer); inline;
procedure lua_remove(L: Plua_State; idx: Integer); inline;
procedure lua_replace(L: Plua_State; idx: Integer); inline;

function lua_tonumber(L: Plua_State; idx: Integer): lua_Number; inline;
function lua_tointeger(L: Plua_State; idx: Integer): lua_Integer; inline;
function lua_tostring(L: Plua_State; idx: Integer): PAnsiChar; inline;

procedure lua_pushglobaltable(L: Plua_State); inline;

function lua_isfunction(L: Plua_State; n: Integer): Boolean; inline;
function lua_istable(L: Plua_State; n: Integer): Boolean; inline;
function lua_islightuserdata(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnil(L: Plua_State; n: Integer): Boolean; inline;
function lua_isboolean(L: Plua_State; n: Integer): Boolean; inline;
function lua_isthread(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnone(L: Plua_State; n: Integer): Boolean; inline;
function lua_isnoneornil(L: Plua_State; n: Integer): Boolean; inline;

(* Compatibility: lua_newuserdata = lua_newuserdatauv(..., 1) *)
function lua_newuserdata(L: Plua_State; sz: size_t): Pointer; inline;
function lua_getuservalue(L: Plua_State; idx: Integer): Integer; inline;
function lua_setuservalue(L: Plua_State; idx: Integer): Integer; inline;

procedure lua_call(L: Plua_State; nargs, nresults: Integer); inline;
function lua_pcall(L: Plua_State; nargs, nresults, errfunc: Integer): Integer; inline;
function lua_yield(L: Plua_State; nresults: Integer): Integer; inline;

implementation

function lua_upvalueindex(i: Integer): Integer;
begin
  Result := LUA_REGISTRYINDEX - i;
end;

procedure lua_pop(L: Plua_State; n: Integer);
begin
  lua_settop(L, -n - 1);
end;

procedure lua_newtable(L: Plua_State);
begin
  lua_createtable(L, 0, 0);
end;

procedure lua_register(L: Plua_State; const n: PAnsiChar; f: lua_CFunction);
begin
  lua_pushcfunction(L, f);
  lua_setglobal(L, n);
end;

procedure lua_pushcfunction(L: Plua_State; f: lua_CFunction);
begin
  lua_pushcclosure(L, f, 0);
end;

procedure lua_insert(L: Plua_State; idx: Integer);
begin
  lua_rotate(L, idx, 1);
end;

procedure lua_remove(L: Plua_State; idx: Integer);
begin
  lua_rotate(L, idx, -1);
  lua_pop(L, 1);
end;

procedure lua_replace(L: Plua_State; idx: Integer);
begin
  lua_copy(L, -1, idx);
  lua_pop(L, 1);
end;

function lua_tonumber(L: Plua_State; idx: Integer): lua_Number;
begin
  Result := lua_tonumberx(L, idx, nil);
end;

function lua_tointeger(L: Plua_State; idx: Integer): lua_Integer;
begin
  Result := lua_tointegerx(L, idx, nil);
end;

function lua_tostring(L: Plua_State; idx: Integer): PAnsiChar;
begin
  Result := lua_tolstring(L, idx, nil);
end;

procedure lua_pushglobaltable(L: Plua_State);
begin
  lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS);
end;

function lua_isfunction(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TFUNCTION;
end;

function lua_istable(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TTABLE;
end;

function lua_islightuserdata(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TLIGHTUSERDATA;
end;

function lua_isnil(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNIL;
end;

function lua_isboolean(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TBOOLEAN;
end;

function lua_isthread(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TTHREAD;
end;

function lua_isnone(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) = LUA_TNONE;
end;

function lua_isnoneornil(L: Plua_State; n: Integer): Boolean;
begin
  Result := lua_type(L, n) <= 0;
end;

function lua_newuserdata(L: Plua_State; sz: size_t): Pointer;
begin
  Result := lua_newuserdatauv(L, sz, 1);
end;

function lua_getuservalue(L: Plua_State; idx: Integer): Integer;
begin
  Result := lua_getiuservalue(L, idx, 1);
end;

function lua_setuservalue(L: Plua_State; idx: Integer): Integer;
begin
  Result := lua_setiuservalue(L, idx, 1);
end;

procedure lua_call(L: Plua_State; nargs, nresults: Integer);
begin
  lua_callk(L, nargs, nresults, 0, nil);
end;

function lua_pcall(L: Plua_State; nargs, nresults, errfunc: Integer): Integer;
begin
  Result := lua_pcallk(L, nargs, nresults, errfunc, 0, nil);
end;

function lua_yield(L: Plua_State; nresults: Integer): Integer;
begin
  Result := lua_yieldk(L, nresults, 0, nil);
end;

end.
