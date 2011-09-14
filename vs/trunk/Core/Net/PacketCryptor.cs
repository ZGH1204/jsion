using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Net
{
    public class PacketCryptor : IPacketCryptor
    {
        private const int FSM_ADDER = 0xabcdef;
        private const int FSM_MULIT = 2212;

        private FSM fsm = new FSM(FSM_ADDER, FSM_MULIT);

        public void Encrypt(byte[] bytes, int len = 0)
        {
            len = (len <= 0 ? bytes.Length : len);

            for (int i = 0; i < len; i++)
			{
				bytes[i] = (byte)(bytes[i] ^ fsm.State);
			}
        }

        public void Decrypt(byte[] bytes, int len = 0)
        {
            len = (len <= 0 ? bytes.Length : len);

            for (int i = 0; i < len; i++)
            {
                bytes[i] = (byte)(bytes[i] ^ fsm.State);
            }
        }

        public void Update()
        {
            fsm.UpdateState();
        }
    }
}
