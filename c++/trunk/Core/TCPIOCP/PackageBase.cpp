#include "StdAfx.h"
#include "PackageBase.h"


CPackageBase::CPackageBase(void)
{
	InitializeCriticalSection(&Lok);
	RefCount = 0;
}


CPackageBase::~CPackageBase(void)
{
	DeleteCriticalSection(&Lok);
}
