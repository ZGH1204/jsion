using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GameBase.Net;

namespace GameBase
{
    public delegate void ReceiveDelegate(GamePacket packet);

    public delegate void DisconnectDelegate(ClientBase client);
}
