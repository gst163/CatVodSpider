@echo off
setlocal
cd /d "%~dp0"

echo 开始编译 Java 代码 + 构建 APK...
call gradlew.bat compileReleaseJavaWithJavac assembleRelease --no-daemon -x lint

if %errorlevel% neq 0 (
    echo 构建失败！
    exit /b 1
)

echo 生成最终 Jar...
call jar\genJar.bat %1

endlocal
exit /b 0
