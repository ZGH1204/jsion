package knightage.net.packets
{
	import core.net.GamePacket;
	
	public class RegistePacket extends GamePacket
	{
		public function RegistePacket()
		{
			super(PacketCodes.Regist);
		}
		
		public var nickName:String;
		
		override public function writeData():void
		{
			writeUTF(nickName);
		}
	}
}