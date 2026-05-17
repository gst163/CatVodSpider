@echo off
setlocal
cd /d "%~dp0"

echo ==============================
echo  开始自动构建 ...
echo ==============================

call gradlew.bat assembleRelease --no-daemon
if %errorlevel% neq 0 (
    echo 构建失败！
    exit /b 1
)

call jar\genJar.bat %1

echo 打包完成！
endlocal
exit /b 0
