-- Пример вызова модуля mymodule (C-модуль на Pascal) из Lua 5.4
-- Запуск: lua test_mymodule.lua  (из каталога example, где лежит mymodule.so / mymodule.dll)
-- На Linux: liblua.so.5.4 в PATH или в LD_LIBRARY_PATH; на Windows: lua54.dll рядом с lua.exe или в PATH.

-- Расширение C-модуля: .so на Unix, .dll на Windows
local is_windows = package.config:sub(1, 1) == '\\'
local ext = is_windows and 'dll' or 'so'
local sep = is_windows and '\\' or '/'

-- Добавляем каталог скрипта и текущий каталог в package.cpath
local script_dir = arg[0]:match('^(.+)[/\\]')
if script_dir and script_dir ~= '' then
  package.cpath = script_dir .. sep .. '?.' .. ext .. ';' .. (package.cpath or '')
end
package.cpath = '.' .. sep .. '?.' .. ext .. ';' .. (package.cpath or '')

local m = require('mymodule')
print(m.hello())
