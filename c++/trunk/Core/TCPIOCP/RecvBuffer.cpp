#include "StdAfx.h"
#include "RecvBuffer.h"

void memcpy_s(char* dest, size_t destSize, char* source, size_t cpySize)
{
	if (destSize < cpySize)
	{
		throw "1";
	}

	::memcpy_s(dest, destSize, source, cpySize);
}


RecvBuffer::RecvBuffer(void)
{
	lpDataBuffer = new char[BUFF_SIZE];
	dataSize = 0;
	m_writeSize = 0;
}

RecvBuffer::RecvBuffer( UINT bufferSize )
{
	lpDataBuffer = new char[bufferSize];
	dataSize = 0;
	m_writeSize = 0;
}

RecvBuffer::~RecvBuffer(void)
{
	delete []lpDataBuffer;
}

size_t RecvBuffer::WriteBuffer( char* buffer, size_t writeLen )
{
	/*if(buffer == NULL)
	{
	return 0;
	}*/

	size_t wl = dataSize - m_writeSize;

	if (writeLen < wl) wl = writeLen;

	try
	{
		memcpy_s(lpDataBuffer + m_writeSize, BUFF_SIZE - m_writeSize, buffer, wl);
	}
	catch (void* e)
	{
		return 0;
	}

	m_writeSize += wl;

	return wl;
}

void RecvBuffer::SetDataSize( size_t dataSize )
{
	dataSize = dataSize;
}

bool RecvBuffer::HasCompletePKG()
{
	return dataSize != 0 && m_writeSize == dataSize;
}

bool RecvBuffer::HasBuffer()
{
	return dataSize != 0;
}

void RecvBuffer::Reset()
{
	dataSize = 0;
	m_writeSize = 0;
}

