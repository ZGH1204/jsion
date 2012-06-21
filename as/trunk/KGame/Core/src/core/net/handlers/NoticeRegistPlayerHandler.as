package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import jsion.debug.DEBUG;

	public class NoticeRegistPlayerHandler implements IPacketHandler
	{
		public function NoticeRegistPlayerHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.NoticeRegist;
		}
		
		public function handle(pkg:GamePacket):void
		{
			DEBUG.debug("通知注册玩家角色");
		}
	}
}