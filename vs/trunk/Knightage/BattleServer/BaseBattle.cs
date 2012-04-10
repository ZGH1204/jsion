using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BattleServer
{
    public class BaseBattle
    {
        protected bool m_finished;

        public virtual void Update(long tick)
        {
        }

        public virtual bool CanFinish()
        {
            return m_finished;
        }

        public virtual void Finish()
        {
        }
    }
}
