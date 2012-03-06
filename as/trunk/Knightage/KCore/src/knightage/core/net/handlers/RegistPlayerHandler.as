package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.KPacket;
	import knightage.core.net.PacketCodes;
	
	public class RegistPlayerHandler implements IPacketHandler
	{
		public function RegistPlayerHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.Regist;
		}
		
		public function handle(pkg:KPacket):void
		{
			t("玩家角色注册");
		}
	}
}