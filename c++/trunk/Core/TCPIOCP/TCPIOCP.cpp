// 这是主 DLL 文件。

#include "stdafx.h"

#include "TCPIOCP.h"

LPACCEPT_DATA CreateAcceptData(SOCKET *s, SOCKADDR_IN addr);


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

void CTCPIOCP::StopListen()
{
	printf("停止商品监听!");
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

	m_lpAcceptData = CreateAcceptData(&m_socket, m_addr);

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

		if (s == NULL)
		{
			//break;
			continue;
		}

		lpAcceptData = CreateAcceptData(&s, addr);

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
			continue;
		}

		if (bRet == FALSE)
		{
			continue;
		}

		printf("I/O操作完成。\r\n");

		switch(lpIOCPData->OPType)
		{
		case SENDED:
			{
				EnterCriticalSection(&(lpAcceptData->SendLok));

				lpAcceptData->sendBytesTransferred += bytesTransferred;

				LeaveCriticalSection(&(lpAcceptData->SendLok));

				lpCTCPIOCP->_SendAsync(lpAcceptData);
			}
			break;
		case RECVED:
			{
				lpCTCPIOCP->OnRecvData(lpIOCPData, bytesTransferred);

				lpCTCPIOCP->_RecvAsync(lpAcceptData);
			}
			break;
		}
	}

	return 0;
}

LPACCEPT_DATA CreateAcceptData(SOCKET *s, SOCKADDR_IN addr)
{
	LPACCEPT_DATA lpAcceptData = new ACCEPT_DATA;

	//lpAcceptData = (LPACCEPT_DATA)GlobalAlloc(GPTR, sizeof(ACCEPT_DATA));

	lpAcceptData->Socket = *s;
	lpAcceptData->SockAddr = addr;
	lpAcceptData->Sending = false;
	lpAcceptData->SendDataLeft = 0;
	lpAcceptData->sendBytesTotal = 0;
	lpAcceptData->sendBytesTransferred = 0;
	InitializeCriticalSection(&(lpAcceptData->SendLok));
	InitializeCriticalSection(&(lpAcceptData->SendPKGListLok));

	lpAcceptData->SenderCryptor = new NoneCryptor;
	lpAcceptData->RecverCryptor = new NoneCryptor;

	lpAcceptData->Sender = (LPIOCP_DATA)GlobalAlloc(GPTR, sizeof(IOCP_DATA));
	lpAcceptData->Recver = (LPIOCP_DATA)GlobalAlloc(GPTR, sizeof(IOCP_DATA));

	lpAcceptData->Sender->LPAcceptData = lpAcceptData;
	lpAcceptData->Recver->LPAcceptData = lpAcceptData;

	lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
	lpAcceptData->Sender->WSABuf.buf = lpAcceptData->Sender->Buffer;
	lpAcceptData->Recver->WSABuf.len = BUFF_SIZE;
	lpAcceptData->Recver->WSABuf.buf = lpAcceptData->Recver->Buffer;

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
	if (lpAcceptData->Socket == INVALID_SOCKET)
	{
		return;
	}

	ZeroMemory(&(lpAcceptData->Recver->WSAOverLapped), sizeof(WSAOVERLAPPED));

	DWORD dwFlags = 0;
	DWORD bytesRecvs = 0;

	if (WSARecv(lpAcceptData->Socket, &(lpAcceptData->Recver->WSABuf), 1, &bytesRecvs, &dwFlags, &(lpAcceptData->Recver->WSAOverLapped), NULL) == NULL)
	{
		int errorID = WSAGetLastError();

		if (errorID != WSA_IO_PENDING)
		{
			//TODO: 异步接收数据失败
		}
	}
}

void CTCPIOCP::_SendAsync( LPACCEPT_DATA lpAcceptData )
{
	//printf("启动异步发送数据。\r\n");

	if(lpAcceptData->sendBytesTransferred == lpAcceptData->sendBytesTotal)
	{//单次整个数据缓冲区发送完成。

		//TODO: 检查数据包队列里是否还有数据包未发送。


		EnterCriticalSection(&(lpAcceptData->SendPKGListLok));

		if (lpAcceptData->SendPKGList.size() != 0)
		{//TODO: 数据包队列里有数据包未发送。
			while(lpAcceptData->sendBytesTotal != BUFF_SIZE && lpAcceptData->SendPKGList.size() != 0)
			{
				CPackageBase* lpPKG = lpAcceptData->SendPKGList.front();

				const char* pBuffer = (const char*)((char*)lpPKG + sizeof(lpPKG->Lok) + sizeof(lpPKG->RefCount));
				int bufferSize = *(int*)pBuffer;

				lpAcceptData->SenderCryptor->Encrypt(pBuffer, lpAcceptData->SendDataLeft, bufferSize, lpAcceptData->Sender->Buffer, lpAcceptData->sendBytesTotal, BUFF_SIZE);

				if (lpAcceptData->SendDataLeft == bufferSize)
				{
					lpAcceptData->SendDataLeft = 0;
					lpAcceptData->SendPKGList.pop();

					EnterCriticalSection(&(lpPKG->Lok));
						lpPKG->RefCount--;

						if (lpPKG->RefCount == 0)
						{
							delete lpPKG;
						}
					LeaveCriticalSection(&(lpPKG->Lok));

					lpAcceptData->SenderCryptor->UpdateCryptKey();
				}
			}

			LeaveCriticalSection(&(lpAcceptData->SendPKGListLok));
		}
		else
		{
			//TODO: 数据包队列为空。
			EnterCriticalSection(&(lpAcceptData->SendLok));

			lpAcceptData->Sending = false;
			/*lpAcceptData->SendDataLeft = 0;
			lpAcceptData->sendBytesTotal = 0;
			lpAcceptData->sendBytesTransferred = 0;
			lpAcceptData->Sender->WSABuf.len = BUFF_SIZE;
			lpAcceptData->Sender->WSABuf.buf = lpAcceptData->Sender->Buffer;*/

			LeaveCriticalSection(&(lpAcceptData->SendLok));

			LeaveCriticalSection(&(lpAcceptData->SendPKGListLok));

			return;
		}
	}

	ZeroMemory(&(lpAcceptData->Sender->WSAOverLapped), sizeof(WSAOVERLAPPED));

	lpAcceptData->Sender->WSABuf.len = lpAcceptData->sendBytesTotal - lpAcceptData->sendBytesTransferred;
	lpAcceptData->Sender->WSABuf.buf = (char*)(lpAcceptData->Sender->Buffer) + lpAcceptData->sendBytesTransferred;

	DWORD dwFlags = 0;
	DWORD bytesTransferred;

	if (WSASend(lpAcceptData->Socket, &(lpAcceptData->Sender->WSABuf), 1, &bytesTransferred, dwFlags, &(lpAcceptData->Sender->WSAOverLapped), NULL) == NULL)
	{
		//TODO: 启动异步发送失败。
	}
	else
	{
		//TODO: 启动异步发送成功。
	}
}

void CTCPIOCP::OnConnectER(char* ip, int port, DWORD errid)
{
	printf("IP: %d，Port: %d 远程终点连接失败! ERRORID：%d \r\n", ip, port, errid);
}

void CTCPIOCP::OnConnectOK(LPACCEPT_DATA lpAcceptData)
{
	printf("远程终点连接成功!");
}

void CTCPIOCP::OnRecvData( LPIOCP_DATA lpIOCPData, int bytesTransferred )
{
	//TODO: 从字节流解析数据包，并缓存不完整的数据包字节流。
	printf("处理接收到的字节流!长度：%d", bytesTransferred);
}

bool CTCPIOCP::SendTCP( CPackageBase* pkg )
{
	return SendTCPImp(this, m_lpAcceptData, pkg);
}

bool WINAPI CTCPIOCP::SendTCPImp( CTCPIOCP* lpCTCPIOCP, LPACCEPT_DATA lpAcceptData, CPackageBase* pkg )
{
	if (lpCTCPIOCP == NULL || lpCTCPIOCP->m_isConnector == false || pkg == NULL || lpAcceptData == NULL)
	{
		delete pkg;

		return false;
	}

	EnterCriticalSection(&(lpAcceptData->SendPKGListLok));

	EnterCriticalSection(&(pkg->Lok));
		pkg->RefCount++;
	LeaveCriticalSection(&(pkg->Lok));

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
