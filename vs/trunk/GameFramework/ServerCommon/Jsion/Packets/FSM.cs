using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ServerCommon.Jsion.Packets
{
    public class FSM
    {
        private int _adder;

        private int _mulitper;

        private int _state;

        private int _count;

        public int Count
        {
            get { return _count; }
        }

        public int State
        {
            get { return (_state & (0xFF << 16)) >> 16; }
        }

        public int Adder
        {
            get { return _adder; }
        }

        public int Mulitper
        {
            get { return _mulitper; }
        }

        public FSM(int adder, int mulitper)
        {
            _adder = adder;
            _mulitper = mulitper;
            _count = 0;

            UpdateState();
        }

        public void Setup(int adder, int mulitper)
        {
            _adder = adder;
            _mulitper = mulitper;

            UpdateState();
        }

        public int UpdateState()
        {
            _state = ((~_state) + _adder) * _mulitper;

            _state = _state ^ (_state >> 16);

            _count++;

            return (_state & (0xFF << 16)) >> 16;
        }
    }
}
