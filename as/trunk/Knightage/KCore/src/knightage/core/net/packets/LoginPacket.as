package knightage.core.net.packets
{
	import knightage.core.net.PacketCodes;
	import knightage.core.net.SLGPacket;

	public class LoginPacket extends SLGPacket
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