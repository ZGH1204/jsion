// stdafx.h : 标准系统包含文件的包含文件，
// 或是经常使用但不常更改的
// 特定于项目的包含文件

#pragma once


#ifndef _DEFINE_IO_DATA
#define _DEFINE_IO_DATA

#pragma comment(lib, "ws2_32.lib")

#define BUFF_SIZE					1024
#define PKG_LEN_BYTES				2


#include <queue>
#include <WinSock2.h>

#include "PackageBase.h"
#include "CryptorBase.h"
#include "RecvBuffer.h"

//////////////////////////////////////////////////////////////////////////
//						完成端口数据
//////////////////////////////////////////////////////////////////////////
struct _ACCEPT_DATA;

typedef enum
{
	RECVED = 1,
	SENDED = 2
}OP_TYPE;

typedef struct _IOCP_DATA
{
	WSAOVERLAPPED					WSAOverLapped;									//重叠I/O对象。
	WSABUF							WSABuf;											//字节缓冲区。
	char							Buffer[BUFF_SIZE];								//具体字节缓冲区。
	_ACCEPT_DATA*					LPAcceptData;									//客户端对象。
	OP_TYPE							OPType;											//操作类型。
	char							PKGLen[PKG_LEN_BYTES];							//用于数据接收时临时储存解密后的数据包长度。

}IOCP_DATA, *LPIOCP_DATA;

typedef struct _ACCEPT_DATA
{
	LPIOCP_DATA						Sender;											//数据发送重叠I/O对象。
	LPIOCP_DATA						Recver;											//数据接收重叠I/O对象。
	CCryptorBase*					SenderCryptor;									//发送数据加密器。
	CCryptorBase*					RecverCryptor;									//接收数据解密器。
	SOCKET							Socket;											//已连接的远程网络套接字。
	SOCKADDR_IN						SockAddr;										//已连接的远程网络端点。
	int								OwnerID;										//拥有者ID。
	std::queue<CPackageBase*>		SendPKGList;									//发送数据包队列。
	CRITICAL_SECTION				SendPKGListLok;									//发送数据包队列互斥信号。
	size_t							SendDataLeft;									//数据包队列第一个数据包已发送的字节数。
	CRITICAL_SECTION				SendLok;										//发送数据互斥信号。
	bool							Sending;										//是否正在发送。
	size_t							sendBytesTotal;									//当前需要发送的总字节数。
	size_t							sendBytesTransferred;							//当前已发送的字节数。
	CRITICAL_SECTION				RecvLok;										//接收数据互斥信号。
	RecvBuffer						RecvBuf;										//接收数据缓冲区，仅当数据包不完整需要拼包时才使用。
	CRITICAL_SECTION				ClosLok;										//关闭客户端互斥信号。
	bool							Closing;										//是否即将关闭。
	size_t							sendPKGCount;									//发送数据包数。
	size_t							recvPKGCount;									//接收数据包数。

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
}ACCEPT_DATA, *LPACCEPT_DATA;



//typedef struct _TEST_PKG
//{
//	short len;
//	int ownerID;
//	int id;
//	char account[20];
//}TEST_PKG;

class TEST_PKG : public CPackageBase
{
public:
	int id;
	char account[20];
};



#endif