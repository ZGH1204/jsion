using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.ServiceProcess;


namespace GameServerService
{
    [RunInstaller(true)]
    public partial class GameServiceInstaller : System.Configuration.Install.Installer
    {
        private ServiceInstaller m_gameServerServiceInstaller;
        private ServiceProcessInstaller m_gameServerServiceProcessInstaller;

        public GameServiceInstaller()
        {
            InitializeComponent();

            m_gameServerServiceProcessInstaller = new ServiceProcessInstaller();
            m_gameServerServiceProcessInstaller.Account = ServiceAccount.LocalSystem;

            m_gameServerServiceInstaller = new ServiceInstaller();
            m_gameServerServiceInstaller.StartType = ServiceStartMode.Manual;
            m_gameServerServiceInstaller.ServiceName = "JsionServer";

            Installers.Add(m_gameServerServiceProcessInstaller);
            Installers.Add(m_gameServerServiceInstaller);
        }
    }
}
