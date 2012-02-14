using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;

namespace CenterServer
{
    public class CnterSrv : ServerBase
    {
        public CnterSrv()
            : base()
        { }

        private static CnterSrv m_server;

        public static CnterSrv Server
        {
            get
            {
                if (m_server == null)
                {
                    m_server = new CnterSrv();
                }

                return m_server;
            }
        }
    }
}
