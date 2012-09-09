#pragma once

#ifndef _CLIENT_BASE
#define _CLIENT_BASE

#include "Stdafx.h"
#include "TCPIOCP.h"

class CClientBase
{
public:
	CClientBase(CTCPIOCP* lpTCP, LPACCEPT_DATA lpAD) { m_lpCTCPIOCP = lpTCP; m_lpAcceptData = lpAD; };
	~CClientBase(void);

public:
	bool SendTCP(CPackageBase* pkg);

private:
	CTCPIOCP*				m_lpCTCPIOCP;
	LPACCEPT_DATA			m_lpAcceptData;
};

#endif