using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Net
{
    public class NoneCryptor : IPacketCryptor
    {
        public void Encrypt(byte[] bytes, int len = 0)
        {
            
        }

        public void Decrypt(byte[] bytes, int len = 0)
        {
            
        }

        public void Update()
        {
            
        }
    }
}
