using System.Net.Sockets;
namespace Net
{
    public delegate void AcceptSocketDelegate(Socket socket);
    public delegate void DisconnectSocketDelegate();

    public delegate void ConnectSocketDelegate(JSocket socket);
    public delegate void ReceivePacketDelegate(Packet packet);
}