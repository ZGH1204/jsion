using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;

namespace GameBase.Managers
{
    public class TimerMgr
    {
        private Timer m_timer;

        private List<TimerAction> m_list;

        public TimerMgr(int interval)
        {
            m_timer = new Timer(interval);
            m_timer.Elapsed += new ElapsedEventHandler(m_timer_Elapsed);
            //m_timer.Enabled = true;

            m_list = new List<TimerAction>();
        }

        void m_timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            for (int i = 0; i < m_list.Count; i++)
            {
                m_list[i].Update(m_timer.Interval);

                if (m_list[i].Finished)
                {
                    m_list.RemoveAt(i);
                    i--;
                }
            }

            if (m_list.Count == 0)
            {
                m_timer.Stop();
            }
        }

        public void AddAction(TimerAction action)
        {
            if (action == null)
            {
                return;
            }

            if (m_list.Count == 0)
            {
                m_timer.Start();
            }

            m_list.Add(action);
        }
    }
}
