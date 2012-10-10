// 这是主 DLL 文件。

#include "stdafx.h"

#include "TCPIOCP.h"

LPACCEPT_DATA CreateAcceptData(SOCKET& s, SOCKADDR_IN& addr);


CTCPIOCP::CTCPIOCP(void)
{
	m_isConnector = false;
	m_lpAcceptData = NULL;
	m_socket = INVALID_SOCKET;
	m_completionPort = INVALID_HANDLE_VALUE;
	m_listenThreadHandle = INVALID_HANDLE_VALUE;
	m_wVersionRequested = MAKEWORD(2, 2);
	InitializeCriticalSection(&m_recvPackagesListLok);
	WSAStartup(m_wVersionRequested, &m_WSAData);
}

CTCPIOCP::~CTCPIOCP(void)
{
	DeleteCriticalSection(&m_recvPackagesListLok);
	StopTCP();
	WSACleanup();
}




bool CTCPIOCP::Listen(int port)
{
	if (m_socket != INVALID_SOCKET)
	{
		return false;
	}

	if (port <= 0 || port > 65535)
	{
		return false;
	}

	/*if (_InitIOCP() == false)
	{
		return false;
	}*/

	m_isConnector = false;

	_InitIOCP();

	m_socket = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, 0, WSA_FLAG_OVERLAPPED);

	if (m_socket == INVALID_SOCKET)
	{
		return false;
	}

	ZeroMemory(&m_addr, sizeof(SOCKADDR_IN));
	m_addr.sin_family = AF_INET;
	m_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	m_addr.sin_port = htons(port);

	if (bind(m_socket, (sockaddr *)&m_addr, sizeof(SOCKADDR_IN)) == SOCKET_ERROR)
	{
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;
		return false;
	}

	if (listen(m_socket, 100) == SOCKET_ERROR)
	{
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;
		return false;
	}

	m_listenThreadHandle = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ListenThreadProc, this, 0, NULL);

	if (m_listenThreadHandle == NULL)
	{
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;
		return false;
	}

	return true;
}


bool CTCPIOCP::Connect(char* ip, int port)
{
	if (m_socket != INVALID_SOCKET || m_lpAcceptData != NULL)
	{
		return false;
	}

	if (port <= 0 || port > 65535)
	{
		return false;
	}

	_InitIOCP();

	m_isConnector = true;

	m_socket = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, 0, WSA_FLAG_OVERLAPPED);

	ZeroMemory(&m_addr, sizeof(SOCKADDR_IN));
	m_addr.sin_family = AF_INET;
	m_addr.sin_addr.s_addr = inet_addr(ip);
	m_addr.sin_port = htons(port);

	if (connect(m_socket, (sockaddr*)&m_addr, sizeof(m_addr)) == SOCKET_ERROR)
	{
		OnConnectER(ip, port, GetLastError());
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;
		return false;
	}

	m_lpAcceptData = CreateAcceptData(m_socket, m_addr);

	m_lpAcceptData->OwnerID = 85643;

	//关联重叠I/O完成端口。
	CreateIoCompletionPort((HANDLE)m_socket, m_completionPort, (DWORD)m_lpAcceptData, 0);

	OnConnectOK(m_lpAcceptData);
	_RecvAsync(m_lpAcceptData);

	return true;
}










bool CTCPIOCP::_InitIOCP()
{
	if (m_completionPort != INVALID_HANDLE_VALUE || m_listenThreadHandle != INVALID_HANDLE_VALUE)
	{
		return false;
	}

	m_completionPort = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0);

	if(m_completionPort == NULL)
	{
		return false;
	}

	SYSTEM_INFO SystemInfo;

	GetSystemInfo(&SystemInfo);

	DWORD ThreadID;
	HANDLE Handle;
	int dwNumberOfProcessors = SystemInfo.dwNumberOfProcessors * 2;

	for (int i = 0; i < dwNumberOfProcessors; i++)
	{
		Handle = CreateThread(NULL, 0, IOCPThreadProc, this, 0, &ThreadID);

		if (Handle == NULL)
		{
			return false;
		}

		CloseHandle(Handle);//仅释放句柄，线程仍然继续工作。
	}

	return true;
}

DWORD WINAPI CTCPIOCP::ListenThreadProc(LPVOID val)
{
	CTCPIOCP* lpCTCPIOCP = (CTCPIOCP*)val;

	SOCKET s;
	SOCKADDR_IN addr;
	int addrSize = sizeof(SOCKADDR_IN);

	LPACCEPT_DATA lpAcceptData;

	while(true)
	{
		s = accept(lpCTCPIOCP->m_socket, (sockaddr*)&addr, &addrSize);
		
		if (s == INVALID_SOCKET)
		{
			printf("接收数据连接失败，退出接收进程。\r\n");
			break;
			//continue;
		}

		lpAcceptData = CreateAcceptData(s, addr);

		//关联重叠I/O完成端口。
		CreateIoCompletionPort((HANDLE)s, lpCTCPIOCP->m_completionPort, (DWORD)lpAcceptData, 0);

		lpCTCPIOCP->OnAccept(lpAcceptData);
		lpCTCPIOCP->_RecvAsync(lpAcceptData);
	}

	return 0;
}

DWORD WINAPI CTCPIOCP::IOCPThreadProc(LPVOID CompletionPort)
{
	CTCPIOCP* lpCTCPIOCP = (CTCPIOCP*)CompletionPort;

	BOOL bRet = FALSE;

	DWORD bytesTransferred = 0;
	LPACCEPT_DATA lpAcceptData = NULL;
	LPIOCP_DATA lpIOCPData = NULL;

	while(TRUE)
	{
		bRet = GetQueuedCompletionStatus(lpCTCPIOCP->m_completionPort, &bytesTransferred, (PULONG_PTR)&lpAcceptData, (LPOVERLAPPED*)&lpIOCPData, INFINITE);

		if (bytesTransferred == 0)
		{
			//TODO: 客户端连接断开。
			printf("客户端连接断开。\r\n");

			EnterCriticalSection(&(lpIOCPData->LPAcceptData->ClosLok));
			lpIOCPData->LPAcceptData->Closing = true;
			LeaveCriticalSection(&(lpIOCPData->LPAcceptData->ClosLok));

			lpCTCPIOCP->OnDisconnected(lpAcceptData);

			continue;
		}

		if (bRet == FALSE)
		{
			continue;
		}

		printf("I/O操作完成。\r\n\r\n");

		switch(lpIOCPData->OPType)
		{
		case SENDED:
			{
				EnterCriticalSection(&(lpAcceptData->SendLok));

				lpAcceptData->sendBytesTransferred += bytesTransferred;

				lpCTCPIOCP->_SendAsync(lpAcceptData);

				LeaveCriticalSection(&(lpAcceptData->SendLok));
			}
			break;
		case RECVED:
			{
				EnterCriticalSection(&(lpAcceptData->RecvLok));

				lpCTCPIOCP->OnRecvData(lpIOCPData, bytesTransferred);
				
				lpCTCPIOCP->_RecvAsync(lpAcceptData);

				LeaveCriticalSection(&(lpAcceptData->RecvLok));
			}
			break;
		}

		EnterCriticalSection(&(lpAcceptData->ClosLok));

		if (lpAcceptData->Closing)
		{
			LeaveCriticalSection(&(lpAcceptData->ClosLok));

			StopAcceptData(lpAcceptData);
		}
		else
		{
			LeaveCriticalSection(&(lpAcceptData->ClosLok));
		}
	}

	return 0;
}

LPACCEPT_DATA CreateAcceptData(SOCKET& s, SOCKADDR_IN& addr)
{
	LPACCEPT_DATA lpAcceptData = new ACCEPT_DATA;

	//lpAcceptData = (LPACCEPT_DATA)GlobalAlloc(GPTR, sizeof(ACCEPT_DATA));

	lpAcceptData->Socket = s;
	lpAcceptData->SockAddr = addr;
	lpAcceptData->OwnerID = 0;
	lpAcceptData->Sending = false;
	lpAcceptData->SendDataLeft = 0;
	lpAcceptData->sendBytesTotal = 0;
	lpAcceptData->sendBytesTransferred = 0;
	lpAcceptData->Closing = false;
	InitializeCriticalSection(&(lpAcceptData->SendLok));
	InitializeCriticalSection(&(lpAcceptData->SendPKGListLok));
	InitializeCriticalSection(&(lpAcceptData->RecvLok));
	InitializeCriticalSection(&(lpAcceptData->ClosLok));

	lpAcceptData->SenderCryptor = new NoneCryptor;
	lpAcceptData->RecverCryptor = new NoneCryptor;

	lpAcceptData->Sender = new IOCP_DATA;//(LPIOCP_DATA)GlobalAlloc(GPTR, sizeof(IOCP_DATA));
	lpAcceptData->Recver = new IOCP_DATA;//(LPIOCP_DATA)GlobalAlloc(GPTR, sizeof(IOCP_DATA));

	lpAcceptData->Sender->LPAcceptData = lpAcceptData;
	lpAcceptData->Recver->LPAcceptData = lpAcceptData;

	lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
	lpAcceptData->Sender->WSABuf.buf = lpAcceptData->Sender->Buffer;
	lpAcceptData->Recver->WSABuf.len = BUFF_SIZE;
	lpAcceptData->Recver->WSABuf.buf = lpAcceptData->Recver->Buffer;

	lpAcceptData->sendPKGCount = 0;
	lpAcceptData->recvPKGCount = 0;

	lpAcceptData->Sender->OPType = SENDED;
	lpAcceptData->Recver->OPType = RECVED;

	return lpAcceptData;
}

void CTCPIOCP::OnAccept(LPACCEPT_DATA lpAcceptData)
{
	printf("客户端请求连接成功。\r\n");
}

void CTCPIOCP::_RecvAsync(LPACCEPT_DATA lpAcceptData)
{
	//printf("启动异步接收数据。\r\n");

	EnterCriticalSection(&(lpAcceptData->RecvLok));

	if (lpAcceptData->Socket == INVALID_SOCKET)
	{
		LeaveCriticalSection(&(lpAcceptData->RecvLok));

		return;
	}

	ZeroMemory(&(lpAcceptData->Recver->WSAOverLapped), sizeof(WSAOVERLAPPED));

	DWORD dwFlags = 0;
	DWORD bytesRecvs = 0;

	if (WSARecv(lpAcceptData->Socket, &(lpAcceptData->Recver->WSABuf), 1, &bytesRecvs, &dwFlags, &(lpAcceptData->Recver->WSAOverLapped), NULL) == SOCKET_ERROR)
	{
		int errorID = WSAGetLastError();

		if (errorID != WSA_IO_PENDING)
		{
			//TODO: 异步接收数据失败
		}
	}

	LeaveCriticalSection(&(lpAcceptData->RecvLok));
}

void CTCPIOCP::_SendAsync( LPACCEPT_DATA lpAcceptData )
{
	//printf("启动异步发送数据。\r\n");

	EnterCriticalSection(&(lpAcceptData->SendLok));

	if(lpAcceptData->sendBytesTransferred == lpAcceptData->sendBytesTotal)
	{//单次整个数据缓冲区发送完成。

		//TODO: 检查数据包队列里是否还有数据包未发送。

		lpAcceptData->sendBytesTotal = 0;
		lpAcceptData->sendBytesTransferred = 0;

		EnterCriticalSection(&(lpAcceptData->SendPKGListLok));

		if (lpAcceptData->SendPKGList.size() != 0)
		{//TODO: 数据包队列里有数据包未发送。
			size_t sTemp = 0;

			while(lpAcceptData->sendBytesTotal != BUFF_SIZE && lpAcceptData->SendPKGList.size() != 0)
			{
				CPackageBase* lpPKG = lpAcceptData->SendPKGList.front();

				const char* pBuffer = (const char*)lpPKG;
				short bufferSize = *(short*)pBuffer;

				sTemp = lpAcceptData->SenderCryptor->Encrypt(pBuffer, lpAcceptData->SendDataLeft, bufferSize, lpAcceptData->Sender->Buffer, lpAcceptData->sendBytesTotal, BUFF_SIZE);

				if(lpAcceptData->SendDataLeft == 0)
				{
					lpAcceptData->SenderCryptor->Encrypt((const char*)(&(lpAcceptData->OwnerID)), 0, sizeof(lpAcceptData->OwnerID), lpAcceptData->Sender->Buffer, lpAcceptData->sendBytesTotal + sizeof(lpPKG->PSize), BUFF_SIZE);
				}

				lpAcceptData->SendDataLeft += sTemp;
				lpAcceptData->sendBytesTotal += sTemp;

				if (lpAcceptData->SendDataLeft == bufferSize)
				{
					lpAcceptData->SendDataLeft = 0;
					lpAcceptData->SendPKGList.pop();
					lpAcceptData->sendPKGCount++;

					lpAcceptData->SenderCryptor->UpdateCryptKey();
				}
			}

			printf("发送成功 %d 个\r\n", lpAcceptData->sendPKGCount);
		}
		else
		{
			//TODO: 数据包队列为空。

			lpAcceptData->Sending = false;
			/*lpAcceptData->SendDataLeft = 0;
			lpAcceptData->sendBytesTotal = 0;
			lpAcceptData->sendBytesTransferred = 0;
			lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
			lpAcceptData->Sender->WSABuf.buf = lpAcceptData->Sender->Buffer;*/
			LeaveCriticalSection(&(lpAcceptData->SendPKGListLok));
			LeaveCriticalSection(&(lpAcceptData->SendLok));
			return;
		}

		LeaveCriticalSection(&(lpAcceptData->SendPKGListLok));
	}

	ZeroMemory(&(lpAcceptData->Sender->WSAOverLapped), sizeof(WSAOVERLAPPED));

	lpAcceptData->Sender->WSABuf.len = lpAcceptData->sendBytesTotal - lpAcceptData->sendBytesTransferred;
	lpAcceptData->Sender->WSABuf.buf = (char*)(lpAcceptData->Sender->Buffer) + lpAcceptData->sendBytesTransferred;

	DWORD dwFlags = 0;
	DWORD bytesTransferred;
	int iErrorID = WSASend(lpAcceptData->Socket, &(lpAcceptData->Sender->WSABuf), 1, &bytesTransferred, dwFlags, &(lpAcceptData->Sender->WSAOverLapped), NULL);

	if (iErrorID == SOCKET_ERROR)
	{
		//TODO: 启动异步发送失败。WSA_IO_PENDING
		iErrorID = WSAGetLastError();
	}
	else
	{
		//TODO: 启动异步发送成功。
		iErrorID = 0;
	}

	LeaveCriticalSection(&(lpAcceptData->SendLok));
}

void CTCPIOCP::OnConnectER(char* ip, int port, DWORD errid)
{
	printf("IP: %d，Port: %d 远程终点连接失败! ERRORID：%d \r\n", ip, port, errid);
}

void CTCPIOCP::OnConnectOK(LPACCEPT_DATA lpAcceptData)
{
	printf("远程终点连接成功!\r\n");
}

void CTCPIOCP::OnRecvData( LPIOCP_DATA lpIOCPData, int bytesTransferred )
{
	//TODO: 从字节流解析数据包，并缓存不完整的数据包字节流。

	EnterCriticalSection(&(lpIOCPData->LPAcceptData->ClosLok));

	if(lpIOCPData->LPAcceptData->Closing) return;

	printf("处理接收到的字节流!长度：%d\r\n", bytesTransferred);

	char* pkg = NULL;
	short pkgLen = 0;
	size_t sTemp = 0;
	size_t sOffset = 0;
	int remain = bytesTransferred;
	CCryptorBase* cryptor = lpIOCPData->LPAcceptData->RecverCryptor;

	if(bytesTransferred == 0)
	{
		printf("客户端连接断开\r\n");
		return;
	}

	//EnterCriticalSection(&m_recvPackagesListLok);

	if (lpIOCPData->LPAcceptData->RecvBuf.HasBuffer())
	{
		size_t writeLen = lpIOCPData->LPAcceptData->RecvBuf.WriteBuffer(lpIOCPData->WSABuf.buf, remain);

		remain = remain - writeLen;

		if (lpIOCPData->LPAcceptData->RecvBuf.HasCompletePKG())
		{
			pkg = new char[BUFF_SIZE];

			sTemp = cryptor->Decrypt(lpIOCPData->LPAcceptData->RecvBuf.lpDataBuffer, 0, lpIOCPData->LPAcceptData->RecvBuf.dataSize, pkg, 0, BUFF_SIZE);
			cryptor->UpdateCryptKey();
			lpIOCPData->LPAcceptData->RecvBuf.Reset();

			sOffset += writeLen;

			lpIOCPData->LPAcceptData->recvPKGCount++;
			HandlePackage(pkg, lpIOCPData);
		}

		if (remain == 0 || lpIOCPData->LPAcceptData->Closing)
		{
			//LeaveCriticalSection(&m_recvPackagesListLok);
			LeaveCriticalSection(&(lpIOCPData->LPAcceptData->ClosLok));
			return;
		}
	}

	while(remain > 0)
	{
		if(lpIOCPData->LPAcceptData->Closing)
		{
			//lpIOCPData->LPAcceptData->RecvBuf.Reset();
			break;
		}

		cryptor->Decrypt((const char*)lpIOCPData->WSABuf.buf, sOffset, bytesTransferred, (char*)lpIOCPData->PKGLen, 0, PKG_LEN_BYTES);
		pkgLen = *(short*)lpIOCPData->PKGLen;																					//取数据包长度

		if (pkgLen > BUFF_SIZE || pkgLen <= 0)
		{																														//非法数据包，断开客户端。
			printf("非法数据包，断开客户端\r\n");
			break;
		}

		if(pkgLen <= remain)
		{																														//接收到一个完整数据包
			pkg = new char[BUFF_SIZE];

			//memcpy_s(pkg, pkgLen, (const char*)(lpIOCPData->WSABuf.buf + (bytesTransferred - remain)), pkgLen);
			sTemp = cryptor->Decrypt((const char*)(lpIOCPData->WSABuf.buf), sOffset, bytesTransferred, pkg, 0, pkgLen);
			cryptor->UpdateCryptKey();
			remain = remain - pkgLen;

			sOffset += sTemp;

			lpIOCPData->LPAcceptData->recvPKGCount++;
			HandlePackage(pkg, lpIOCPData);
		}
		else
		{																														//接收包不完整，放到缓冲区
			lpIOCPData->LPAcceptData->RecvBuf.SetDataSize(pkgLen);

			lpIOCPData->LPAcceptData->RecvBuf.WriteBuffer(lpIOCPData->WSABuf.buf, remain);

			if (lpIOCPData->LPAcceptData->RecvBuf.HasCompletePKG())
			{
				sTemp = 0;

				pkg = new char[BUFF_SIZE];

				sTemp = cryptor->Decrypt(lpIOCPData->LPAcceptData->RecvBuf.lpDataBuffer, 0, lpIOCPData->LPAcceptData->RecvBuf.dataSize, pkg, 0, BUFF_SIZE);
				cryptor->UpdateCryptKey();
				lpIOCPData->LPAcceptData->RecvBuf.Reset();

				sOffset += sTemp;

				lpIOCPData->LPAcceptData->recvPKGCount++;
				HandlePackage(pkg, lpIOCPData);
			}

			break;
		}
	}

	//LeaveCriticalSection(&m_recvPackagesListLok);
	LeaveCriticalSection(&(lpIOCPData->LPAcceptData->ClosLok));
}


void CTCPIOCP::HandlePackage( char* pkg, LPIOCP_DATA lpIOCPData )
{
	//m_recvPackagesList.push(pkg);

	TEST_PKG* p = (TEST_PKG*)(pkg);

	printf("OwnerID: %d, ID: %d, Account: %s, PKGCount: %d\r\n", p->OwnerID, p->id, p->account, lpIOCPData->LPAcceptData->recvPKGCount);
}

void CTCPIOCP::OnDisconnected( LPACCEPT_DATA lpAcceptData )
{
	CTCPIOCP::DeleteAcceptData(lpAcceptData);
}


bool CTCPIOCP::SendTCP( CPackageBase* pkg )
{
	return SendTCPImp(this, m_lpAcceptData, pkg);
}

bool CTCPIOCP::SendTCP2(  )
{
	/*EnterCriticalSection(&(m_lpAcceptData->SendLok));

	if (m_lpAcceptData->Sending == false)
	{
	m_lpAcceptData->Sending = true;
	m_lpAcceptData->SendDataLeft = 0;
	m_lpAcceptData->sendBytesTotal = 0;
	m_lpAcceptData->sendBytesTransferred = 0;
	m_lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
	m_lpAcceptData->Sender->WSABuf.buf = m_lpAcceptData->Sender->Buffer;
	_SendAsync(m_lpAcceptData);
	}

	LeaveCriticalSection(&(m_lpAcceptData->SendLok));*/

	return true;
}

bool WINAPI CTCPIOCP::SendTCPImp( CTCPIOCP* lpCTCPIOCP, LPACCEPT_DATA lpAcceptData, CPackageBase* pkg )
{
	if (lpCTCPIOCP == NULL || lpCTCPIOCP->m_isConnector == false || pkg == NULL || lpAcceptData == NULL)
	{
		return false;
	}

	EnterCriticalSection(&(lpAcceptData->SendPKGListLok));

	lpAcceptData->SendPKGList.push(pkg);

	EnterCriticalSection(&(lpAcceptData->SendLok));

	if (lpAcceptData->Sending == false)
	{
		lpAcceptData->Sending = true;
		lpAcceptData->SendDataLeft = 0;
		lpAcceptData->sendBytesTotal = 0;
		lpAcceptData->sendBytesTransferred = 0;
		lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
		lpAcceptData->Sender->WSABuf.buf = lpAcceptData->Sender->Buffer;
		lpCTCPIOCP->_SendAsync(lpAcceptData);
	}

	LeaveCriticalSection(&(lpAcceptData->SendLok));

	LeaveCriticalSection(&(lpAcceptData->SendPKGListLok));

	return true;
}

void CTCPIOCP::StopAcceptData(LPACCEPT_DATA lpAcceptData)
{
	EnterCriticalSection(&(lpAcceptData->ClosLok));
	
	lpAcceptData->Closing = true;

	EnterCriticalSection(&(lpAcceptData->SendLok));

	if (lpAcceptData->Sending)
	{
		LeaveCriticalSection(&(lpAcceptData->SendLok));

		LeaveCriticalSection(&(lpAcceptData->ClosLok));

		return;
	}

	LeaveCriticalSection(&(lpAcceptData->SendLok));

	closesocket(lpAcceptData->Socket);
	lpAcceptData->Socket = INVALID_SOCKET;

	LeaveCriticalSection(&(lpAcceptData->ClosLok));
}

void CTCPIOCP::DeleteAcceptData( LPACCEPT_DATA lpAcceptData )
{
	EnterCriticalSection(&(lpAcceptData->ClosLok));

	if(lpAcceptData->Closing == false)
	{
		LeaveCriticalSection(&(lpAcceptData->ClosLok));
		return;
	}

	delete lpAcceptData->Sender;
	delete lpAcceptData->Recver;
	delete lpAcceptData->SenderCryptor;
	delete lpAcceptData->RecverCryptor;
	DeleteCriticalSection(&(lpAcceptData->SendPKGListLok));
	DeleteCriticalSection(&(lpAcceptData->SendLok));
	DeleteCriticalSection(&(lpAcceptData->RecvLok));

	LeaveCriticalSection(&(lpAcceptData->ClosLok));

	DeleteCriticalSection(&(lpAcceptData->ClosLok));

	delete lpAcceptData;
}

void CTCPIOCP::StopTCP()
{
	if(m_lpAcceptData == NULL)
	{//作为服务端时
		closesocket(m_socket);
		m_socket = INVALID_SOCKET;

		if(m_listenThreadHandle != INVALID_HANDLE_VALUE)
		{
			//WaitForSingleObject(m_listenThreadHandle, INFINITE);

			CloseHandle(m_listenThreadHandle);

			m_listenThreadHandle = INVALID_HANDLE_VALUE;
		}
	}
	else
	{//作为客户端时
		StopAcceptData(m_lpAcceptData);
	}
}
