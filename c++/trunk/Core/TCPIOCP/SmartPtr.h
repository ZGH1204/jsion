#pragma once

template<class T>
class CSmartPtr
{
//private:
//	static void* operator new (size_t len)
//	{
//		return NULL;
//	}

public:
	CSmartPtr()
	{
		m_lok = (CRITICAL_SECTION*)CMemPool::GetInstance()->Allocate(sizeof(CRITICAL_SECTION));
		InitializeCriticalSection(m_lok);

		m_count = (size_t*)CMemPool::GetInstance()->Allocate(sizeof(size_t));
		*m_count = 1;
		m_cdata = NULL;
	}

	CSmartPtr(const T* pObj)
	{
		_ResetObject(pObj);
	}

	CSmartPtr(const CSmartPtr& obj)
	{
		_RefObject(obj);
	}

	~CSmartPtr()
	{
		_CheckRefCountAndDel();
	}

	T* Get()
	{
		return m_data;
	}

	T* operator ->()
	{
		return m_data;
	}

	CSmartPtr& operator = (CSmartPtr& obj)
	{
		_CheckRefCountAndDel();

		_RefObject(obj);

		return *this;
	}

	CSmartPtr& operator = (const CSmartPtr& obj)
	{
		_CheckRefCountAndDel();

		_RefObject(obj);

		return *this;
	}

	CSmartPtr& operator = (T* obj)
	{
		_CheckRefCountAndDel();

		_ResetObject(obj);

		return *this;
	}

	const CSmartPtr& operator = (const T* pObj)
	{
		_CheckRefCountAndDel();

		_ResetObject(obj);

		return *this;
	}

	bool operator == (const T& pObj)
	{
		return pObj == *m_data;
	}

	bool operator == (const T* pData)
	{
		return pData == m_data;
	}

private:
	void _ResetObject(const T* pObj)
	{
		m_lok = (CRITICAL_SECTION*)CMemPool::GetInstance()->Allocate(sizeof(CRITICAL_SECTION));
		InitializeCriticalSection(m_lok);

		m_count = (size_t*)CMemPool::GetInstance()->Allocate(sizeof(size_t));
		*m_count = 1;
		m_cdata = pObj;
	}
	void _RefObject(const CSmartPtr& obj)
	{
		EnterCriticalSection(obj.m_lok);

		m_lok = obj.m_lok;

		m_count = obj.m_count;

		++*m_count;

		m_cdata = obj.m_cdata;

		LeaveCriticalSection(obj.m_lok);
	}
	void _CheckRefCountAndDel()
	{
		EnterCriticalSection(m_lok);
		--*m_count;
		if(*m_count <= 0)
		{
			if (m_data != NULL)
			{
				delete m_data;
				m_data = NULL;
			}

			LeaveCriticalSection(m_lok);

			DeleteCriticalSection(m_lok);

			CMemPool::GetInstance()->Free(m_lok);
			CMemPool::GetInstance()->Free(m_count);

			printf("ÖÇÄÜÉ¾³ý!\r\n");
		}
		else
		{
			LeaveCriticalSection(m_lok);
		}
	}

private:
	size_t* m_count;
	union
	{
		T* m_data;
		const T* m_cdata;
	};
	CRITICAL_SECTION* m_lok;
};

