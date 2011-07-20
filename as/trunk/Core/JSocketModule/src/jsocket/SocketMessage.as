package jsocket
{
	/**
	 * Socket模块消息标识（0——20）
	 * @author Jsion
	 * 
	 */	
	public class SocketMessage
	{
		////////////////////////////////	用于设置的消息		////////////////////////////////
		
		/**
		 * <p>设置数据包类</p>
		 * <p><b>消息标识：</b>0</p>
		 * <p><b>wParam: </b>数据包类的引用</p>
		 */		
		public static const SetPacketClass:uint = 0;
		
		/**
		 * <p>设置发送数据包加密器</p>
		 * <p><b>消息标识：</b>1</p>
		 * <p><b>wParam: </b>加密器(IPacketCryptor)对象</p>
		 */		
		public static const SetSendCryptor:uint = 1;
		
		/**
		 * <p>设置发送数据包解密器</p>
		 * <p><b>消息标识：</b>2</p>
		 * <p><b>wParam: </b>解密器(IPacketCryptor)对象</p>
		 */		
		public static const SetReceiveCryptor:uint = 2;
		
		////////////////////////////////	允许接收并处理的消息		////////////////////////////////
		/**
		 * <p>连接远程端口消息</p>
		 * <p><b>消息标识：</b>11</p>
		 * <p><b>wParam: </b>IP地址</p>
		 * <p><b>lParam: </b>端口号</p>
		 * <p><b>消息类型：</b>接收</p>
		 */		
		public static const Connect:uint = 11;
		
		/**
		 * <p>强制连接远程端口消息</p>
		 * <p><b>消息标识：</b>12</p>
		 * <p><b>wParam: </b>IP地址</p>
		 * <p><b>lParam: </b>端口号</p>
		 * <p><b>消息类型：</b>接收</p>
		 */		
		public static const ForceConnect:uint = 12;
		
		/**
		 * <p>发送数据包</p>
		 * <p><b>消息标识：</b>13</p>
		 * <p><b>wParam: </b>数据包对象</p>
		 * <p><b>消息类型：</b>接收</p>
		 */		
		public static const Send:uint = 13;
		
		/**
		 * <p>关闭当前连接消息</p>
		 * <p><b>消息标识：</b>14</p>
		 * <p><b>消息类型：</b>接收</p>
		 */		
		public static const Close:uint = 14;
		
		
		
		
		
		////////////////////////////////	发送消息列表		////////////////////////////////
		
		/**
		 * <p>连接成功时发送</p>
		 * <p><b>消息标识：</b>16</p>
		 * <p><b>消息类型：</b>发送</p>
		 */		
		public static const Connected:uint = 16;
		
		/**
		 * <p>发生错误时发送</p>
		 * <p><b>消息标识：</b>17</p>
		 * <p><b>wParam: </b>错误文本提示</p>
		 * <p><b>消息类型：</b>发送</p>
		 */		
		public static const Errored:uint = 17;
		
		/**
		 * <p>连接关闭时发送</p>
		 * <p><b>消息标识：</b>18</p>
		 * <p><b>消息类型：</b>发送</p>
		 */		
		public static const Closed:uint = 18;
		
		/**
		 * <p>收到数据包时发送</p>
		 * <p><b>消息标识：</b>19</p>
		 * <p><b>wParam: </b>数据包对象</p>
		 * <p><b>消息类型：</b>发送</p>
		 */		
		public static const Received:uint = 19;
	}
}