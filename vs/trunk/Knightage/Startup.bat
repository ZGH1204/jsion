@echo off

@rem echo 当前批处理路径：%~dp0


%~d0
cd %~dp0CenterServerApp\bin\Debug
echo 启动中心服务器...
start CenterServerApp.exe


if 1 == 0 (
cd %~dp0CacheServerApp\bin\Debug
echo 启动缓存服务器...
start CacheServerApp.exe
)


cd %~dp0GameServerApp\bin\Debug
echo 启动游戏服务器...
start GameServerApp.exe


cd %~dp0BattleServerApp\bin\Debug
echo 启动战斗服务器...
start BattleServerApp.exe


cd %~dp0GatewayServerApp\bin\Debug
echo 启动网关服务器...
start GatewayServerApp.exe

@rem pause