// TCPClient.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"


CTCPIOCP client;


int _tmain(int argc, _TCHAR* argv[])
{
	for (int i = 0; i < 1; i++)
	{
		CTCPIOCP* lpClient = new CTCPIOCP;

		if(lpClient->Connect("127.0.0.1", 3000))
		{
			printf("连接服务器成功！\r\n");
		}

		//TestPackage* pkg = new TestPackage;

		//for (int i = 0; i < 100; i++)
		//{
		//	//TestPackage* pkg = new TestPackage;
		//	//pkg->id = i + 1;
		//	//printf("发送数据包！\r\n");
		//	client.SendTCP(pkg);
		//}

		//client.SendTCP2();

		//client.StopTCP();
	}

	printf("按任意键退出!\r\n");

	_getch();

	return 1;
}

