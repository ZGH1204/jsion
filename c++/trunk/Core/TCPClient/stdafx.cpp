// stdafx.cpp : 只包括标准包含文件的源文件
// TCPClient.pch 将作为预编译头
// stdafx.obj 将包含预编译类型信息

#include "stdafx.h"

// TODO: 在 STDAFX.H 中
// 引用任何所需的附加头文件，而不是在此文件中引用

TestPackage::TestPackage()
{
	PSize = sizeof(TestPackage);

	//id = 223;
	tLong = 4300000000;
	strcpy_s(account, "jsion");
}

TestPackage::~TestPackage()
{

}
