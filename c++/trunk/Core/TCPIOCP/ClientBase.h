#pragma once

#ifndef _CLIENT_BASE
#define _CLIENT_BASE

#include "Stdafx.h"
#include "TCPIOCP.h"

class CClientBase
{
public:
	CClientBase(LPACCEPT_DATA lpAD, CTCPIOCP* lpTCP) { m_lpCTCPIOCP = lpTCP; m_lpAcceptData = lpAD; };
	~CClientBase(void);

public:
	bool SendTCP(CSmartPtr<CPackageBase> pkg);

private:
	LPACCEPT_DATA			m_lpAcceptData;
	CTCPIOCP*				m_lpCTCPIOCP;
};

#endif