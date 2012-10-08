#pragma once

#ifndef _CRYPTOR_BASE
#define _CRYPTOR_BASE


class CCryptorBase
{
public:
	CCryptorBase(void);
	~CCryptorBase(void);

public:
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

public:
	virtual size_t Encrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize);
	virtual size_t Decrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize);
	virtual void UpdateCryptKey();
};


class NoneCryptor : public CCryptorBase
{
	size_t Encrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize);

	size_t Decrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize);

	void UpdateCryptKey();
};

#endif