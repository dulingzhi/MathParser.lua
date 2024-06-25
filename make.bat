@echo off

cd /d %~dp0

call .\vendor\squish_to_one\make_lua.bat %CD%\src

pause
