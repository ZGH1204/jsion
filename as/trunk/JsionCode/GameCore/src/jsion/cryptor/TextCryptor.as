package jsion.cryptor
{
	import flash.utils.ByteArray;
	
	/**
	 * 文本压缩加密实现
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 * 
	 */	
	public class TextCryptor implements ICryption
	{
		/**
		 * 加密
		 * @param bytes 要加密的原始数据
		 * @return 加密后的新数据，不修改原始数据。
		 * @see jsion.core.cryptor.ICryption#encry()
		 */		
		public function encry(bytes:ByteArray):ByteArray
		{
			var rlt:ByteArray = new ByteArray();
			
			bytes.position = 0;
			bytes.readBytes(rlt);
			
			rlt.position = 0;
			rlt.compress();
			
			rlt.position = 0;
			
			return rlt;
		}
		
		/**
		 * 解密
		 * @param bytes 要解密的加密数据
		 * @return 解密后的新数据，不修改加密数据。
		 * @see jsion.core.cryptor.ICryption#decry()
		 */		
		public function decry(bytes:ByteArray):ByteArray
		{
			var rlt:ByteArray = new ByteArray();
			
			bytes.position = 0;
			bytes.readBytes(rlt);
			
			rlt.position = 0;
			rlt.uncompress();
			
			rlt.position = 0;
			
			return rlt;
		}
	}
}