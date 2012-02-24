package knightage.core.net.packets
{
	import knightage.core.net.GatewayPacket;
	import knightage.core.net.PacketCodes;

	public class LoginPacket extends GatewayPacket
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