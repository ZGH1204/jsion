// WinServiceDemo.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "BaseService.h"

BaseService srv;

int _tmain(int argc, _TCHAR* argv[])
{
	char szPath[MAX_PATH];

	if ( GetModuleFileName( NULL, szPath, MAX_PATH ) == 0 ) return false;

	srv.Create(szPath, "JsionServiceDemo");

	return 0;
}

