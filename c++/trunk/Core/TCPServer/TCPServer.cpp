// TCPServer.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

#define _CRTDBG_MAP_ALLOC
#include <stdlib.h>
#include <crtdbg.h>

CTCPIOCP server;

int _tmain(int argc, _TCHAR* argv[])
{
	if (server.Listen(3000))
	{
		printf("监听端口：%d 成功!\r\n", 3000);
	}

	printf("按任意键退出!\r\n");

	_getch();
	_CrtDumpMemoryLeaks();
 	return 1;
}

