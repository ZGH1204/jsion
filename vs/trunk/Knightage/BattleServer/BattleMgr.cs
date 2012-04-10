using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using log4net;
using System.Reflection;
using JUtils;

namespace BattleServer
{
    public class BattleMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static readonly long THREAD_INTERVAL = 40;

        private static bool m_running = false;

        private static List<BaseBattle> m_battles = new List<BaseBattle>(500);

        private static Thread m_thread = new Thread(new ThreadStart(BattleThread));

        private static BaseBattleEmitter m_emitter;

        public static void SetEmitter(BaseBattleEmitter emitter)
        {
            m_emitter = emitter;

            m_emitter.SetBattles(m_battles);
        }

        public static void Start()
        {
            if (m_running == false)
            {
                if (m_emitter == null) SetEmitter(new BaseBattleEmitter());

                m_running = true;
                m_thread.Start();
                log.Info("战斗线程启动!");
            }
        }

        public static void Stop()
        {
            if (m_running)
            {
                m_running = false;
                m_thread.Join();
                log.Info("战斗线程停止!");
            }
        }

        private static void BattleThread()
        {
            long balance = 0;

            while (m_running)
            {
                long start = TickUtil.GetTicks();

                try
                {
                    m_emitter.Emitte(start);
                }
                catch (Exception ex)
                {
                    log.Error("Battle Mgr Thread Error:", ex);
                }

                long end = TickUtil.GetTicks();

                balance += THREAD_INTERVAL - (end - start);

                if (balance > 0)
                {
                    Thread.Sleep((int)balance);
                    balance = 0;
                }
                else
                {
                    if (balance < -1000)
                    {
                        log.WarnFormat("Battle Mgr is delay {0} ms!", balance);
                        balance += 1000;
                    }
                }
            }
        }
    }
}
