#pragma once

#ifndef _CPACKAGE_BASE
#define _CPACKAGE_BASE

#include <Windows.h>

class CPackageBase
{
public:
	CPackageBase(void) ;
	~CPackageBase(void);

public:
	CRITICAL_SECTION		Lok;
	int						RefCount;
	int						PSize;
};


#endif