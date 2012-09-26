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
	void* pRtn;

	EnterCriticalSection(&m_lok);

	int index = allocaLen / ALIGN_SIZE;

	if (m_lpMemoryPool[index] == NULL)
	{
		_AllocateMemory(allocaLen);
	}

	LPMEMORY_BLOCK& pBlock = m_lpMemoryPool[index];

	LPMEMORY_BLOCK temp = pBlock->Next;

	pBlock->Next = NULL;

	pRtn = pBlock->Data;

	pBlock = temp;

	LeaveCriticalSection(&m_lok);

	return pRtn;
}

void CMemPool::Free( void* pData )
{
	if(pData == NULL) return;

	EnterCriticalSection(&m_lok);

	LPMEMORY_BLOCK pObj = (LPMEMORY_BLOCK)((char*)pData - sizeof(MEMORY_BLOCK) + sizeof(char*));

	pObj->Next = NULL;

	int index = pObj->Size / ALIGN_SIZE;

	LPMEMORY_BLOCK& pBlock = m_lpMemoryPool[index];

	if(pBlock == NULL)
	{
		pBlock = pObj;
	}
	else
	{
		pObj->Next = pBlock;
		pBlock = pObj;
	}

	LeaveCriticalSection(&m_lok);
}

void CMemPool::_AllocateMemory(size_t s)
{
	size_t alignSize = s;//对齐要申请的字节空间
	if(s % ALIGN_SIZE != 0)
	{
		alignSize = alignSize + ALIGN_SIZE - s % ALIGN_SIZE;
	}

	size_t allocSize = alignSize + sizeof(MEMORY_BLOCK);
	//if (allocSize % ALIGN_SIZE != 0)
	//{//对齐字节
	//	allocSize = ALIGN_SIZE - allocSize % ALIGN_SIZE + allocSize;//添加头信息后再次对齐字节空间
	//}

	size_t count = MAX_MEMORY_SIZE / allocSize + 1;

	count = max(count, MIN_ALLOC_COUNT);

	char* memory = new char[allocSize * count];

	LPMEMORY_BLOCK& lpMem = m_lpMemoryPool[s / ALIGN_SIZE];

	size_t cur = 0;

	if (lpMem == NULL)
	{
		lpMem = (LPMEMORY_BLOCK)memory;

		lpMem->Size = s;
		lpMem->Next = NULL;

		memory = memory + allocSize;

		cur = 1;
	}

	while(cur < count)
	{
		LPMEMORY_BLOCK temp = (LPMEMORY_BLOCK)memory;

		temp->Size = s;
		temp->Next = lpMem;

		lpMem = temp;

		lpMem->Next = NULL;

		memory = memory + allocSize;

		cur++;
	}
}
