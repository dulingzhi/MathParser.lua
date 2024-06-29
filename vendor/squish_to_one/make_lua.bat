@echo off

echo %~dp1
pushd %~dp1
lua51 "%~dp0squish" %1 --minify-level=full --no-uglify
popd
