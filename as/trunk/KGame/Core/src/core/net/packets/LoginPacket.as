package core.net.packets
{
	import core.net.GamePacket;
	
	public class LoginPacket extends GamePacket
	{
		public function LoginPacket()
		{
			super(PacketCodes.Login);
		}
		
		public var account:String;
		
		override public function writeData():void
		{
			writeUTF(account);
		}
	}
}