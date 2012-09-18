#include "StdAfx.h"
#include "MemPool.h"


CMemPool CMemPool::s_instance;

CMemPool::CMemPool(void)
{
	size_t count = MAX_MEMORY_SIZE / ALIGN_SIZE;

	if ((MAX_MEMORY_SIZE % ALIGN_SIZE) != 0)
	{
		count += 1;
	}

	m_lpMemoryPool = new LPMEMORY_BLOCK[count];

	ZeroMemory(m_lpMemoryPool, sizeof(LPMEMORY_BLOCK) * count);

	InitializeCriticalSection(&m_lok);
}


CMemPool::~CMemPool(void)
{
	DeleteCriticalSection(&m_lok);
}

CMemPool* CMemPool::GetInstance()
{
	return &s_instance;
}

void* CMemPool::Allocate( size_t allocaLen )
{


	return NULL;
}

void CMemPool::_AllocateMemory(size_t s)
{
	size_t allocSize = s + sizeof(MEMORY_BLOCK);

	if (allocSize % ALIGN_SIZE != 0)
	{//¶ÔÆë×Ö½Ú
		allocSize = ALIGN_SIZE - allocSize % ALIGN_SIZE + s;
	}

	size_t count = MAX_MEMORY_SIZE / allocSize;

	count = max(count, MIN_ALLOC_COUNT);

	char* memory = new char[allocSize * count];

	LPMEMORY_BLOCK& lpMem = m_lpMemoryPool[s / ALIGN_SIZE];

	size_t cur = 0;

	if (lpMem == NULL)
	{
		lpMem = (LPMEMORY_BLOCK)memory;

		memory = memory + allocSize;

		cur = 1;
	}

	while(cur < count)
	{
		LPMEMORY_BLOCK temp = (LPMEMORY_BLOCK)memory;

		temp->Next = lpMem;

		lpMem = temp;

		memory = memory + allocSize;

		cur++;
	}
}
