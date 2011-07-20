using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace GameServerService
{
    partial class GameService : ServiceBase
    {
        public GameService()
        {
            InitializeComponent();

            this.ServiceName = "JsionServer";
            this.AutoLog = false;
            this.CanHandlePowerEvent = false;
            this.CanPauseAndContinue = false;
            this.CanShutdown = true;
            this.CanStop = true;
        }

        protected override void OnStart(string[] args)
        {
            // TODO: 在此处添加代码以启动服务。

            Console.WriteLine("Server is started!!!");
        }

        protected override void OnStop()
        {
            // TODO: 在此处添加代码以执行停止服务所需的关闭操作。

            Console.WriteLine("Server is stoped!!!");
        }
    }
}
