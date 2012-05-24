package jsion.core.cryptor
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
		 * @copy jsion.core.cryptor.ICryption#encry()
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
		 * @copy jsion.core.cryptor.ICryption#decry()
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