#include "StdAfx.h"
#include "ClientBase.h"

CClientBase::~CClientBase(void)
{
}

bool CClientBase::SendTCP( CPackageBase* pkg )
{
	return CTCPIOCP::SendTCPImp(m_lpCTCPIOCP, m_lpAcceptData, pkg);
}
