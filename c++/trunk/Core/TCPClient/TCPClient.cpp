// TCPClient.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"


CTCPIOCP client;

void testConnect()
{
	CSmartPtr<CPackageBase> pkg = new TestPackage();

	TestPackage* p = (TestPackage*)pkg.Get();
	p->id = 1;

	for (int i = 0; i < 10; i++)
	{
		CTCPIOCP* lpClient = new CTCPIOCP;

		if(lpClient->Connect("127.0.0.1", 3000))
		{
			printf("连接服务器成功！\r\n");
		}

		for (int i = 0; i < 1; i++)
		{
			//TestPackage* pkg = new TestPackage;
			//p->id = i + 1;
			//printf("发送数据包！\r\n");
			lpClient->SendTCP(pkg);
			lpClient->SendTCP(pkg);
		}

		//client.SendTCP2();

		//client.StopTCP();
	}
}


int _tmain(int argc, _TCHAR* argv[])
{
	testConnect();

	printf("按任意键退出!\r\n");

	_getch();

	return 1;
}

