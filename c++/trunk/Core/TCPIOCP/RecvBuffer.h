#pragma once

class RecvBuffer
{
public:
	RecvBuffer(void);
	RecvBuffer(UINT bufferSize);
	~RecvBuffer(void);


public:
	bool HasBuffer();
	void SetDataSize(size_t ds);
	size_t WriteBuffer(char* buffer, size_t writeLen);
	bool HasCompletePKG();
	void Reset();

public:
	char*							lpDataBuffer;					//缓冲区
	size_t							dataSize;						//所需写入缓冲区的总大小


private:
	size_t							m_writeSize;					//已写入缓冲区的数据大小
};

