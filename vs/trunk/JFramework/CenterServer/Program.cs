using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlugIn.Core;
using BattleHeartGame;

namespace CenterServer
{
    class Program
    {
        static void Main(string[] args)
        {
            CoreStartup.Startup(GameGloba.Start);
        }
    }
}
