package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SLGPacket;
	
	public class NoticeLoginHandler implements IPacketHandler
	{
		public function NoticeLoginHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.NoticLogin;
		}
		
		public function handle(pkg:SLGPacket):void
		{
			t("通知客户端登陆");
		}
	}
}