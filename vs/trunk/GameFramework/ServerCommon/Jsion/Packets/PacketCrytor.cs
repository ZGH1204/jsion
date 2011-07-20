using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JsionFramework.Jsion.Interfaces;

namespace ServerCommon.Jsion.Packets
{
    public class PacketCrytor : ICrytPackage
    {
        private static readonly int FSM_ADDER = 0xabcdef;
        private static readonly int FSM_MULIT = 2212;

        private FSM send_fsm, receive_fsm;

        private int send_state, receive_state;

        public PacketCrytor()
        {
            send_fsm = new FSM(FSM_ADDER, FSM_MULIT);
            receive_fsm = new FSM(FSM_ADDER, FSM_MULIT);

            send_state = send_fsm.State;
            receive_state = receive_fsm.State;
        }

        public byte Encryt(byte b)
        {
            //return b;
            return ((byte)(b ^ send_state));
        }

        public byte Decryt(byte b)
        {
            //return b;
            return ((byte)(b ^ receive_state));
        }

        public void EncrytOnceComplete()
        {
            send_state = send_fsm.UpdateState();
        }

        public void DecrytOnceComplete()
        {
            receive_state = receive_fsm.UpdateState();
        }
    }
}
