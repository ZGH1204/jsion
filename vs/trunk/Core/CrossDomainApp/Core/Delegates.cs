using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;

namespace CrossDomainApp.Core
{
    public delegate void AcceptSocketDelegate(Socket socket);
    public delegate void DisconnectSocketDelegate(Socket socket);
}
