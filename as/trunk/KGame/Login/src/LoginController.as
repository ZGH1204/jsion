package
{
	import core.net.SocketProxy;
	
	import jsion.IDispose;
	
	public class LoginController implements IDispose
	{
		public function LoginController()
		{
		}
		
		public function connectServer():void
		{
			SocketProxy.connect(Config.ServerIP, Config.ServerPort);
		}
		
		public function dispose():void
		{
		}
	}
}