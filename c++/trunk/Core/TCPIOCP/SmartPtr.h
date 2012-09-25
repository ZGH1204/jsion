#pragma once

template<class T>
class CSmartPtr
{
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
		m_lok = (CRITICAL_SECTION*)CMemPool::GetInstance()->Allocate(sizeof(CRITICAL_SECTION));
		InitializeCriticalSection(m_lok);

		m_count = (size_t*)CMemPool::GetInstance()->Allocate(sizeof(size_t));
		*m_count = 1;
		m_cdata = pObj;
	}

	CSmartPtr(const CSmartPtr& obj)
	{
		m_lok = obj->m_lok;

		m_count = obj->m_count;

		++*m_count;

		m_cdata = obj->m_cdata;
	}

	~CSmartPtr()
	{
		_CheckRefCountAndDel();
	}

	T* Get()
	{
		return m_data;
	}

	CSmartPtr& operator = (const CSmartPtr& obj)
	{
		_CheckRefCountAndDel();

		EnterCriticalSection(m_lok);

		CRITICAL_SECTION* tempLok = m_lok;

		EnterCriticalSection(obj->m_lok);

		m_lok = obj->m_lok;

		m_count = obj->m_count;

		++*m_count;

		m_cdata = obj->m_cdata;

		LeaveCriticalSection(obj->m_lok);

		LeaveCriticalSection(tempLok);

		return *this;
	}

private:
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

