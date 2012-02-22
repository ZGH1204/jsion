using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;
using GameBase.Datas;

namespace GameBase
{
    public class Player
    {
        public uint PlayerID { get; protected set; }

        public string Account { get; protected set; }

        public string NickName { get; protected set; }

        public ClientBase Client { get; protected set; }

        public PlayerInfo PlayerInfo { get; protected set; }

        public Player(PlayerInfo info, ClientBase client)
        {
            PlayerID = info.PlayerID;
            Account = info.Account;
            NickName = info.NickName;
            Client = client;
            Client.Player = this;
        }

        public void SendTcp(GamePacket pkg)
        {
            Client.SendTcp(pkg);
        }

        public virtual void Logined()
        {
            //TODO: 加载玩家其他信息
        }

        public virtual void Logout()
        {
            //TODO: 发送被踢下线数据包
        }

        public virtual void OnDisconnect()
        {
        }
    }
}
