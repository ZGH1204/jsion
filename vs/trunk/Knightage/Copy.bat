@echo off

echo 当前批处理路径：%~dp0

xcopy %~d0CenterServerApp\bin\Debug %~d0SLG\CenterServerApp\bin\Debug /F /E /Y /I

xcopy %~d0BattleServerApp\bin\Debug %~d0SLG\BattleServerApp\bin\Debug /F /E /Y /I

xcopy %~d0GameServerApp\bin\Debug %~d0SLG\GameServerApp\bin\Debug /F /E /Y /I

xcopy %~d0GatewayServerApp\bin\Debug %~d0SLG\GatewayServerApp\bin\Debug /F /E /Y /I

copy %~d0Startup.bat %~d0SLG\Startup.bat

copy %~d0Closed.bat %~d0SLG\Closed.bat