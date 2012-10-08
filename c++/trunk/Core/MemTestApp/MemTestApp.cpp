// MemTestApp.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <queue>

void memTest()
{
	std::queue<char*> list;

	printf("按任意键分配内存...\r\n");
	_getch();

	for (int i = 0; i < 1000; i++)
	{
		list.push(new char[1024]);
	}

	printf("按任意键回收内存...\r\n");
	_getch();

	for (int i = 0; i < 1000; i++)
	{
		char* c = list.front();

		list.pop();

		delete[] c;
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	for (int i = 0; i < 100; i++)
	{
		memTest();

		printf("按任意键再来一次...\r\n");
		_getch();
	}

	return 0;
}

