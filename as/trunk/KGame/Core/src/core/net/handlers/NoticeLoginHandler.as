package core.net.handlers
{
	import core.login.LoginMgr;
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	import core.net.SocketProxy;
	import core.net.packets.LoginPacket;
	
	import jsion.debug.DEBUG;

	public class NoticeLoginHandler implements IPacketHandler
	{
		public function NoticeLoginHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.NoticLogin;
		}
		
		public function handle(pkg:GamePacket):void
		{
			DEBUG.debug("通知客户端登陆");
			
			var lPkg:LoginPacket = new LoginPacket();
			
			lPkg.account = LoginMgr.account;
			
			SocketProxy.sendTCP(lPkg);
		}
	}
}