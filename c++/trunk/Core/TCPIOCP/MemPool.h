#pragma once


#ifndef _MEMORY_POOL
#define _MEMORY_POOL


#define MAX_MEMORY_SIZE			1024 * 4				//申请内存空间大小基准值
#define ALIGN_SIZE				8						//内存空间对齐大小
#define MIN_ALLOC_COUNT			5						//内存池中申请空间最小个数


class CMemPool
{
private:
	typedef struct _MEMORY_BLOCK
	{
		size_t						Size;
		union
		{
			_MEMORY_BLOCK*			Next;
			char					Data[1];
		};
	}MEMORY_BLOCK, *LPMEMORY_BLOCK;

public:
	CMemPool(void);
	~CMemPool(void);


public:
	static CMemPool* GetInstance();
	void* Allocate(size_t allocaLen);					//获取指定大小的字节空间
	void Free(void* pData);								//释放指定空间到缓冲池

private:
	void _AllocateMemory(size_t s);						//按字节对齐分配内存空间

private:
	static CMemPool	s_instance;
	CRITICAL_SECTION m_lok;
	LPMEMORY_BLOCK* m_lpMemoryPool;
};





#endif

