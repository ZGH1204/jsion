package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import jsion.debug.DEBUG;

	public class RegistFailedHandler implements IPacketHandler
	{
		public function get code():int
		{
			return PacketCodes.RegistFailed;
		}
		
		public function handle(pkg:GamePacket):void
		{
			DEBUG.error("玩家角色注册失败");
		}
	}
}