package knightage.core.net.handlers
{
	import knightage.core.net.IPacketHandler;
	import knightage.core.net.KPacket;
	import knightage.core.net.PacketCodes;
	
	public class MsgHandler implements IPacketHandler
	{
		public function MsgHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.Msg;
		}
		
		public function handle(pkg:KPacket):void
		{
			var msg:int = pkg.readShort();
			
			t("消息提示 消息号：", msg);
		}
	}
}