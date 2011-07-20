using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JUtils.Messages;
using GameCore;

namespace BattleHeartGame
{
    public class GameGloba
    {
        public static void Start()
        {
            string sender = typeof(GameGloba).Name;

            MsgMonitor.CreateAndSendMsg(MsgGloba.SetSocketType, 
                                        sender, 
                                        new string[] { ServiceGloba.Center_ListenServiceID, ServiceGloba.ConnecterID }, 
                                        typeof(Server));

            MsgMonitor.CreateAndSendMsg(MsgGloba.Listen, 
                                        sender, 
                                        new string[] { ServiceGloba.Center_ListenServiceID }, 
                                        2212);

            //MsgMonitor.CreateAndSendMsg(MsgGloba.Connect,
            //                            sender,
            //                            new string[] { ServiceGloba.ConnecterID },
            //                            "192.168.16.119",
            //                            7810);
        }
    }
}
