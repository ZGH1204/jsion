package jsion.cryptor
{
	import flash.utils.ByteArray;
	
	/**
	 * 加密接口
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public interface ICryption
	{
		/**
		 * 加密
		 * @param bytes 要加密的原始数据
		 * @return 加密后的新数据，不修改原始数据。
		 * 
		 */		
		function encry(bytes:ByteArray):ByteArray;
		
		/**
		 * 解密
		 * @param bytes 要解密的加密数据
		 * @return 解密后的新数据，不修改加密数据。
		 * 
		 */		
		function decry(bytes:ByteArray):ByteArray;
	}
}