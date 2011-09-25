package jsion.core.cryptor
{
	import flash.utils.ByteArray;
	
	public class TextCryptor implements ICryption
	{
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