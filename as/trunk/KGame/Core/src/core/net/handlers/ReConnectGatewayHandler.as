package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	import core.net.SocketProxy;
	
	import jsion.debug.DEBUG;

	public class ReConnectGatewayHandler implements IPacketHandler
	{
		public function ReConnectGatewayHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.ReConnect;
		}
		
		public function handle(pkg:GamePacket):void
		{
			DEBUG.debug("重连网关服务器");
			
			var clientID:int = pkg.readInt();
			
			var ip:String = pkg.readUTF();
			
			var port:int = pkg.readInt();
			
			SocketProxy.forceConnect(ip, port);
		}
	}
}