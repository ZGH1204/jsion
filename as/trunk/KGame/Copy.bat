@echo off

echo 当前批处理路径：%~dp0

rd /S /Q %~dp0release

pause

xcopy %~dp0Loader\bin-debug\assets %~d0release\assets /F /E /Y /I
xcopy %~dp0Assets\libs %~d0release\assets\module /F /E /Y /I
xcopy %~dp0Core\bin %~d0release\assets\module /F /E /Y /I
xcopy %~dp0DebugLogin\bin %~d0release\assets\module /F /E /Y /I
xcopy %~dp0Loading\bin %~d0release\assets\module /F /E /Y /I
xcopy %~dp0Login\bin %~d0release\assets\module /F /E /Y /I

copy %~dp0Loader\bin-debug\Loader.swf %~d0release\Loader.swf

copy %~dp0Loader\src\config.xml %~d0release\config.xml