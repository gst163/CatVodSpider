@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ==============================================
echo          开始自动构建 custom_spider.jar
echo ==============================================

:: 清理旧文件
echo [1/5] 清理旧文件...
del /f /q "%~dp0\custom_spider.jar" 2>nul
del /f /q "%~dp0\custom_spider.jar.md5" 2>nul
rd /s /q "%~dp0\Smali_classes" 2>nul

:: 反编译 APK
echo [2/5] 反编译 APK 抽取 Smali...
java -jar "%~dp0\3rd\apktool_2.11.0.jar" d -f --only-main-classes "%~dp0\..\app\build\outputs\apk\release\app-release-unsigned.apk" -o "%~dp0\Smali_classes"

:: 删除旧 Smali
echo [3/5] 替换旧的 Smali 文件...
rd /s /q "%~dp0\spider.jar\smali\com\github\catvod\spider" 2>nul
rd /s /q "%~dp0\spider.jar\smali\com\github\catvod\js" 2>nul
rd /s /q "%~dp0\spider.jar\smali\org\slf4j" 2>nul

:: 创建目录
if not exist "%~dp0\spider.jar\smali\com\github\catvod\" md "%~dp0\spider.jar\smali\com\github\catvod\"
if not exist "%~dp0\spider.jar\smali\org\slf4j\" md "%~dp0\spider.jar\smali\org\slf4j\"

:: 移动新 Smali
move "%~dp0\Smali_classes\smali\com\github\catvod\spider" "%~dp0\spider.jar\smali\com\github\catvod\"
move "%~dp0\Smali_classes\smali\com\github\catvod\js" "%~dp0\spider.jar\smali\com\github\catvod\"
move "%~dp0\Smali_classes\smali\org\slf4j" "%~dp0\spider.jar\smali\org\slf4j\"

:: 打包 Jar
echo [4/5] 打包生成新 Jar...
java -jar "%~dp0\3rd\apktool_2.11.0.jar" b "%~dp0\spider.jar" -c

:: 移动最终文件
move /y "%~dp0\spider.jar\dist\dex.jar" "%~dp0\custom_spider.jar"

:: 生成 MD5
echo [5/5] 生成 MD5 校验值...
certUtil -hashfile "%~dp0\custom_spider.jar" MD5 | find /i /v "md5" | find /i /v "certutil" > "%~dp0\custom_spider.jar.md5"

:: 清理临时文件
echo 清理临时文件...
rd /s /q "%~dp0\spider.jar\build" 2>nul
rd /s /q "%~dp0\spider.jar\smali" 2>nul
rd /s /q "%~dp0\spider.jar\dist" 2>nul
rd /s /q "%~dp0\Smali_classes" 2>nul

echo.
echo ==============================================
echo           ✅ 打包完成！
echo         输出：custom_spider.jar
echo ==============================================
echo.

endlocal
exit /b 0find /i /v "certutil" > "%~dp0\custom_spider.jar.md5"

rd /s/q "%~dp0\spider.jar\build"
rd /s/q "%~dp0\spider.jar\smali"
rd /s/q "%~dp0\spider.jar\dist"
rd /s/q "%~dp0\Smali_classes"
