using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JUtils.Net
{
    public interface IPacketCryptor
    {
        void Encrypt(byte[] bytes, int len = 0);
        void Decrypt(byte[] bytes, int len = 0);
        void Update();
    }
}
