@echo off

echo 关闭网关服务器...
taskkill /f /t /im GatewayServerApp.exe

echo 关闭战斗服务器...
taskkill /f /t /im BattleServerApp.exe

echo 关闭游戏服务器...
taskkill /f /t /im GameServerApp.exe

if 1 == 0 (
echo 关闭缓存服务器...
taskkill /f /t /im CacheServerApp.exe
)

echo 关闭中心服务器...
taskkill /f /t /im CenterServerApp.exe

@rem pause