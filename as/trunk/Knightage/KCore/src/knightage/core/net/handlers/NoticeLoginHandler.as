package knightage.core.net.handlers
{
	import knightage.core.mgrs.LoginMgr;
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.KPacket;
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SocketProxy;
	import knightage.core.net.packets.LoginPacket;
	
	public class NoticeLoginHandler implements IPacketHandler
	{
		public function NoticeLoginHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.NoticLogin;
		}
		
		public function handle(pkg:KPacket):void
		{
			t("通知客户端登陆");
			
			var lPkg:LoginPacket = new LoginPacket();
			
			lPkg.account = LoginMgr.Instance.account;
			
			SocketProxy.send(lPkg);
		}
	}
}