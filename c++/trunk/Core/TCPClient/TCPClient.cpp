// TCPClient.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"


CTCPIOCP client;


int _tmain(int argc, _TCHAR* argv[])
{
	if(client.Connect("127.0.0.1", 3000))
	{
		printf("连接服务器成功！");
	}

	TestPackage* pkg = new TestPackage;

	client.SendTCP(pkg);

	printf("按任意键退出!\r\n");

	_getch();

	return 1;
}

