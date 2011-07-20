package jsocket.net
{
	public class PacketFactory
	{
		private static var packetClass:Class = Packet;
		
		private static var _sendCryptor:IPacketCryptor = new PacketCryptor();
		private static var _receiveCryptor:IPacketCryptor = new PacketCryptor();
		
		public static function get sendCryptor():IPacketCryptor
		{
			return _sendCryptor;
		}
		
		public static function get receiveCryptor():IPacketCryptor
		{
			return _receiveCryptor;
		}
		
		public static function setPacketClass(cls:Class):void
		{
			if(cls == null) return;
			packetClass = cls;
		}
		
		public static function setSendCryptor(cryptor:IPacketCryptor):void
		{
			if(cryptor == null) cryptor = new NoneCryptor();
			_sendCryptor = cryptor;
		}
		
		public static function setReceiveCryptor(cryptor:IPacketCryptor):void
		{
			if(cryptor == null) cryptor = new NoneCryptor();
			_receiveCryptor = cryptor;
		}
		
		public static function createPacket():Packet
		{
			return new packetClass() as Packet;
		}
	}
}