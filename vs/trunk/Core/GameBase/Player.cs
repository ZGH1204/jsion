using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase
{
    public class Player
    {
        public uint PlayerID { get; protected set; }

        public string Account { get; protected set; }

        public ClientBase Client { get; protected set; }

        public Player(uint playerID, string account, ClientBase client)
        {
            PlayerID = playerID;
            Account = account;
            Client = client;
        }

        public void SendTcp(GamePacket pkg)
        {
            Client.SendTcp(pkg);
        }

        public virtual void Logined()
        {
        }

        public virtual void Logout()
        {
        }

        public virtual void OnDisconnect()
        {
        }
    }
}
