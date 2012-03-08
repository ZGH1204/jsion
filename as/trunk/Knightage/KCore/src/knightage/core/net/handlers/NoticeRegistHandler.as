package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.KPacket;
	import knightage.core.net.PacketCodes;
	
	public class NoticeRegistHandler implements IPacketHandler
	{
		public function NoticeRegistHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.NoticeRegist;
		}
		
		public function handle(pkg:KPacket):void
		{
			t("通知客户端弹出角色注册UI或界面");
		}
	}
}