package core.net.handlers
{
	import core.net.GamePacket;
	import core.net.IPacketHandler;

	public class LoginHandler implements IPacketHandler
	{
		public function LoginHandler()
		{
		}
		
		public function get code():int
		{
			return PacketCodes.Login;
		}
		
		public function handle(pkg:GamePacket):void
		{
			trace("LoginHandler");
		}
	}
}