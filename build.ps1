# Build mymodule.dll (Lua 5.4 C module) with Free Pascal.
# Requires: FPC in PATH (e.g. from fpcupdeluxe) and lua54.dll.

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SrcDir = Join-Path $ScriptDir 'src'
$ExampleDir = Join-Path $ScriptDir 'example'

# Optional: set FPC path from fpcupdeluxe
if ($env:FPCUPDELUXE) {
    $fpc64 = Join-Path $env:FPCUPDELUXE 'fpc\bin\x86_64-win64'
    if (Test-Path $fpc64) { $env:PATH = "$fpc64;$env:PATH" }
}

Write-Host 'Building mymodule (Lua 5.4 module)...'
& fpc -MObjFPC -Scghi -O2 -Twin64 -Px86_64 "-Fu$SrcDir" "-Fi$SrcDir" (Join-Path $ExampleDir 'mymodule.lpr')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host "Output: $ExampleDir\mymodule.dll"
Write-Host 'Place mymodule.dll where Lua can find it (see package.cpath) and ensure lua54.dll is nearby or in PATH.'
Write-Host 'Test: lua54 -e "local m = require(''mymodule''); print(m.hello())"'
