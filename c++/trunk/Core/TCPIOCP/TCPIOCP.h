// TCPIOCP.h

#pragma once

#ifndef JSION_TCP_IOCP
#define JSION_TCP_IOCP

#pragma comment(lib, "ws2_32.lib")

#include <queue>
#include <stdio.h>
#include <tchar.h>
#include <WinSock2.h>


#include "Stdafx.h"
#include "RecvBuffer.h"
#include "PackageBase.h"



//////////////////////////////////////////////////////////////////////////
//							完成端口实现类
//////////////////////////////////////////////////////////////////////////
class CTCPIOCP
{
public:
	CTCPIOCP(void);																	//构造函数。
	~CTCPIOCP(void);																//析构函数。

public:
	bool Listen(int port);															//监听本地端口。
	bool Connect(char* ip, int port);												//连接到指定的远程网络终点。

	bool SendTCP(CPackageBase* pkg);												//仅作为客户端去连接远程服务端时可用。
	bool SendTCP2();																//仅作为客户端去连接远程服务端时可用。

	void StopTCP();																	//停止TCP。

public:
	virtual void OnAccept(LPACCEPT_DATA lpAcceptData);								//收到连接请求后调用的方法。
	virtual void OnConnectER(char* ip, int port, DWORD errid);						//连接失败，其中 errid 为通过 GetLastError() 取得。
	virtual void OnConnectOK(LPACCEPT_DATA lpAcceptData);							//连接成功。
	virtual void OnRecvData(LPIOCP_DATA lpIOCPData, int bytesTransferred);			//接收到客户端数据。
	virtual void HandlePackage(char* pkg, LPIOCP_DATA lpIOCPData);					//处理数据包。
	virtual void OnDisconnected(LPACCEPT_DATA lpAcceptData);						//客户端断开连接。

public:
	static CTCPIOCP* Listener;
	static bool WINAPI SendTCPImp(CTCPIOCP* lpCTCPIOCP, LPACCEPT_DATA lpAcceptData, CPackageBase* pkg);			//发送数据包实现方法。
	static void StopAcceptData(LPACCEPT_DATA lpAcceptData);							//停止客户端连接。
	static void DeleteAcceptData(LPACCEPT_DATA lpAcceptData);						//关闭并释放连接。

private:
	static DWORD WINAPI	IOCPThreadProc(LPVOID CompletionPort);						//I/O操作的完成通知线程池关联方法。
	static DWORD WINAPI ListenThreadProc(LPVOID val);								//监听线程关联方法。

private:
	bool _InitIOCP();																//创建完成端口句柄，并且创建2倍于CPU核心数的线程池(仅创建一次完成端口和对应的线程池)。
	void _RecvAsync(LPACCEPT_DATA lpAcceptData);									//启动异步接收数据。
	void _SendAsync(LPACCEPT_DATA lpAcceptData);									//启动异步发送数据。

private:
	WORD m_wVersionRequested;														//一个WORD（双字节）型数值，指定了应用程序需要使用的Winsock规范的最高版本。
	WSADATA m_WSAData;																//用来接收Windows Sockets实现的细节。
	SOCKET m_socket;																//网络套接字句柄。
	SOCKADDR_IN m_addr;																//网络端点。
	HANDLE m_listenThreadHandle;													//监听线程句柄。
	HANDLE m_completionPort;														//关联指定Socket的完成端口句柄。
	bool m_isConnector;																//是否作为客户端去连接远程服务端。
	LPACCEPT_DATA m_lpAcceptData;													//作为客户端去连接远程服务端时有效。

	//std::queue<LPVOID> m_recvPackagesList;											//全局待处理数据包队列。
	CRITICAL_SECTION m_recvPackagesListLok;											//全局待处理数据包队列互斥信号。
};

#endif