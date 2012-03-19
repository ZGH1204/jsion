using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase;
using GameBase.Datas;

namespace GameServer
{
    public class GamePlayer : Player
    {
        public int ClientID { get; set; }

        public new GameClient Client { get; protected set; }

        public GamePlayer(LoginInfo info, GameClient client)
            : base(info, client)
        {
            Client = client;
        }

        public override void Logined()
        {
            base.Logined();
        }

        public override void Logout()
        {
            base.Logout();
        }

        public override void OnDisconnect()
        {
            base.OnDisconnect();
        }

        public virtual void SaveToDatabase()
        {
        }
    }
}
