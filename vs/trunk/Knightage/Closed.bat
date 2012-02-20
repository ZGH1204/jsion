@echo off

echo 关闭网关服务器...
taskkill /f /t /im GatewayServerApp.exe

echo 关闭战斗服务器...
taskkill /f /t /im BattleServerApp.exe

echo 关闭游戏服务器...
taskkill /f /t /im GameServerApp.exe

echo 关闭中心服务器...
taskkill /f /t /im CenterServerApp.exe

pause