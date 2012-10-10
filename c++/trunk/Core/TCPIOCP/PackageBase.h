#pragma once

#ifndef _CPACKAGE_BASE
#define _CPACKAGE_BASE

#include "MemPool.h"
#include <Windows.h>

class CPackageBase
{
public:
	static void* operator new (size_t len)
	{
		return CMemPool::GetInstance()->Allocate(len);
	}

	static void* operator new(size_t len, const char* file, int line)
	{
		return CMemPool::GetInstance()->Allocate(len);
	}

	static void operator delete(void* lpObj)
	{
		CMemPool::GetInstance()->Free(lpObj);
	}

public:
	CPackageBase(void) ;
	~CPackageBase(void);

public:
	short					PSize;
	int						OwnerID;
};


#endif