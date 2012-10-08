#include "StdAfx.h"
#include "CryptorBase.h"
#include <memory.h>


CCryptorBase::CCryptorBase(void)
{
}


CCryptorBase::~CCryptorBase(void)
{
}

size_t CCryptorBase::Encrypt( const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize )
{
	return 0;
}

size_t CCryptorBase::Decrypt( const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize )
{
	return 0;
}

void CCryptorBase::UpdateCryptKey()
{

}



size_t NoneCryptor::Encrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize)
{
	if (sourceSize <= sourceOffset || destSize <= destOffset)
	{
		return 0;
	}

	size_t slen = sourceSize - sourceOffset;
	size_t tlen = destSize - destOffset;

	if(slen > tlen) slen = tlen;

	memcpy_s((char*)(dest + destOffset), tlen, (const char*)(source + sourceOffset), slen);

	return slen;
}

size_t NoneCryptor::Decrypt(const char* source, size_t sourceOffset, size_t sourceSize, char* dest, size_t destOffset, size_t destSize)
{
	if (sourceSize <= sourceOffset || destSize <= destOffset)
	{
		return 0;
	}

	size_t slen = sourceSize - sourceOffset;
	size_t tlen = destSize - destOffset;

	if(slen > tlen) slen = tlen;

	memcpy_s((char*)(dest + destOffset), tlen, (const char*)(source + sourceOffset), slen);

	return slen;
}

void NoneCryptor::UpdateCryptKey()
{

}