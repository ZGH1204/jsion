package jsion.socket
{
	public class PacketFactory
	{
		private static var packetClass:Class = Packet;
		
		private static var _sendCryptor:IPacketCryptor = new PacketCryptor();
		private static var _receiveCryptor:IPacketCryptor = new PacketCryptor();
		
		/**
		 * 获取发送数据包时的加密器
		 */		
		public static function get sendCryptor():IPacketCryptor
		{
			return _sendCryptor;
		}
		
		/**
		 * 获取接收数据包时的解密器
		 */		
		public static function get receiveCryptor():IPacketCryptor
		{
			return _receiveCryptor;
		}
		
		/**
		 * 设置数据包类
		 * @param cls 数据包类对象
		 */		
		public static function setPacketClass(cls:Class):void
		{
			if(cls == null) return;
			packetClass = cls;
		}
		
		/**
		 * 设置发送数据包时的加密器
		 * @param cryptor 加密器
		 */		
		public static function setSendCryptor(cryptor:IPacketCryptor):void
		{
			if(cryptor == null) cryptor = new NoneCryptor();
			_sendCryptor = cryptor;
		}
		
		/**
		 * 设置接收数据包时的解密器
		 * @param cryptor 解密器
		 * 
		 */		
		public static function setReceiveCryptor(cryptor:IPacketCryptor):void
		{
			if(cryptor == null) cryptor = new NoneCryptor();
			_receiveCryptor = cryptor;
		}
		
		/**
		 * 创建数据包对象
		 */		
		public static function createPacket():Packet
		{
			return new packetClass() as Packet;
		}
	}
}