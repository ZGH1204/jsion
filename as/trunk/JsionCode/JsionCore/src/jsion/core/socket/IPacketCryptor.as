package jsion.core.socket
{
	/**
	 * 数据包加密接口
	 * @author Jsion
	 * 
	 */	
	public interface IPacketCryptor
	{
		/**
		 * 加密字节数组
		 * @param bytes 要加密的字节数组
		 * 
		 */		
		function encrypt(bytes:Packet):void;
		
		/**
		 * 解密字节数组
		 * @param bytes 要解密的字节数组
		 * 
		 */		
		function decrypt(bytes:Packet):void;
		
		/**
		 * 更新密钥
		 */		
		function update():void;
	}
}