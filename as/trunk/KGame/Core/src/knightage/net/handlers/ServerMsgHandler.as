package knightage.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;
	
	import jsion.lang.Local;
	
	import knightage.display.Alert;
	
	public class ServerMsgHandler implements IPacketHandler
	{
		public function ServerMsgHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.ServerMsg;
		}
		
		public function handle(pkg:GamePacket):void
		{
			var flag:int = pkg.readShort();
			
			var msg:String = Local.getTrans(flag.toString());
			
			Alert.show(msg);
		}
	}
}