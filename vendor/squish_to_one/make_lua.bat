@echo off

echo %~dp1
pushd %~dp1
lua %~dp0/squish %1 --minify-level=full --no-uglify
popd
