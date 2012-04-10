using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BattleServer
{
    public class BaseBattleEmitter
    {
        protected List<BaseBattle> m_battles;

        public virtual void SetBattles(List<BaseBattle> battles)
        {
            m_battles = battles;
        }

        public virtual void Emitte(long tick)
        {
            for (int i = 0; i < m_battles.Count; i++)
            {
                m_battles[i].Update(tick);

                if (m_battles[i].CanFinish())
                {
                    m_battles[i].Finish();
                    m_battles.RemoveAt(i);

                    i -= 1;
                }
            }
        }
    }
}
