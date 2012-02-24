package knightage.core.net
{
	public class PacketCodes
	{
		/**
		 * 转发给逻辑服务器
		 */		
		public static const LogicCode:int = 3;
		
		/**
		 * 重新连接其他网关服务器
		 */		
		public static const ReConnect:int = 1001;
		
		/**
		 * 服务器满载,无法继续连接.
		 */		
		public static const ServerBusies:int = 1002;
		
		/**
		 * 连接验证成功,通知客户端发送登陆包.
		 */		
		public static const NoticLogin:int = 1011;
		
		/**
		 * 登陆
		 */		
		public static const Login:int = 1012;
	}
}