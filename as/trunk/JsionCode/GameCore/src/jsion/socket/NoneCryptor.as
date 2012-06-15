package jsion.socket
{
	/**
	 * 无加密操作
	 * @author Jsion
	 * 
	 */	
	public class NoneCryptor implements IPacketCryptor
	{
		public function NoneCryptor()
		{
		}
		
		public function encrypt(bytes:Packet):void
		{
		}
		
		public function decrypt(bytes:Packet):void
		{
		}
		
		public function update():void
		{
		}
	}
}