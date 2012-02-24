package knightage.login
{
	import jsion.IDispose;
	import jsion.core.messages.Msg;
	import jsion.core.messages.MsgReceiver;
	import jsion.utils.BrowserUtil;
	import jsion.utils.StringUtil;
	
	import knightage.core.Config;
	import knightage.core.MsgFlag;
	import knightage.core.mgrs.LoginMgr;
	import knightage.core.net.SocketProxy;
	import knightage.core.net.packets.LoginPacket;

	public class LoginController extends MsgReceiver
	{
		public static const LoginReceiverID:String = "LoginReceiver";
		
		private var m_account:String;
		
		public function LoginController(account:String)
		{
			m_account = account;
			
			LoginMgr.Instance.account = m_account;
			LoginMgr.Instance.logined = false;
			
			super(LoginReceiverID);
			
			registeReceive(MsgFlag.SocketConnected, onConnected);
		}
		
		private function onConnected(msg:Msg):void
		{
			t("Socket is connected!");
		}
		
		public function connectServer():void
		{
			if(Config.config.Debug)
			{
				var ip:String = BrowserUtil.getVal("ip") as String;
				var port:int = int(BrowserUtil.getVal("port"));
				
				if(StringUtil.isNotNullOrEmpty(ip) && port > 0)
				{
					SocketProxy.connect(ip, port);
					return;
				}
			}
			
			SocketProxy.connect(Config.config.SrvIP, Config.config.SrvPort);
		}
		
		override public function dispose():void
		{
			removeReceive(MsgFlag.SocketConnected);
			
			super.dispose();
		}
	}
}