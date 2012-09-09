#include "StdAfx.h"
#include "CryptorBase.h"
#include <memory.h>


CCryptorBase::CCryptorBase(void)
{
}


CCryptorBase::~CCryptorBase(void)
{
}

void CCryptorBase::Encrypt( const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize )
{

}

void CCryptorBase::Decrypt( const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize )
{

}

void CCryptorBase::UpdateCryptKey()
{

}



void NoneCryptor::Encrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize)
{
	if (sourceSize <= sourceOffset || destSize <= destOffset)
	{
		return;
	}

	size_t slen = sourceSize - sourceOffset;
	size_t tlen = destSize - destOffset;

	if(slen > tlen) slen = tlen;

	memcpy_s((char*)(dest + destOffset), tlen, (const char*)(source + sourceOffset), slen);

	sourceOffset += slen;
	destOffset += slen;
}

void NoneCryptor::Decrypt(const char* source, size_t& sourceOffset, size_t sourceSize, char* dest, size_t& destOffset, size_t destSize)
{
	if (sourceSize <= sourceOffset || destSize <= destOffset)
	{
		return;
	}

	size_t slen = sourceSize - sourceOffset;
	size_t tlen = destSize - destOffset;

	if(slen > tlen) slen = tlen;

	memcpy_s((char*)(dest + destOffset), tlen, (const char*)(source + sourceOffset), slen);

	sourceOffset += slen;
	destOffset += slen;
}

void NoneCryptor::UpdateCryptKey()
{

}