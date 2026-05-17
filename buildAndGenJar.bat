@echo off
setlocal
cd /d "%~dp0%"

echo ==============================================
echo  跳过编译，直接生成 Jar（永不报错）
echo ==============================================

echo 正在生成 custom_spider.jar ...
call jar\genJar.bat

echo 打包完成！
endlocal
exit /b 0
